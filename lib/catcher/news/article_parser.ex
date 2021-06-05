defmodule Catcher.News.ArticleParser do
  alias Catcher.News.Article

  @expected__body_fields ~w(
    total_hits page total_pages page_size articles user_input
  )

  def parse(body) do
    pageable =
      body
      |> Jason.decode!()
      |> Map.take(@expected__body_fields)
      |> Map.update!("articles", fn values -> deserialize_articles(values) end)
      |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    page = %{
      mode: "search-engine",
      page: pageable.page,
      per_page: pageable.page_size,
      total_counts: pageable.total_hits,
      total_pages: pageable.total_pages,
      search_engine_inputs: pageable.user_input
    }

    {pageable.articles, page}
  end

  defp deserialize_articles(articles) do
    articles
    |> Enum.map(fn article ->
      article
      |> Map.take(Article.string_keys())
      |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
    end)
  end
end
