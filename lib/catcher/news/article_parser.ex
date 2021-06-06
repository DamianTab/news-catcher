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
      |> Map.update!("articles", fn v -> deserialize_articles(v) end)
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
      |> Map.take(Catcher.News.ParamsHelper.struct_keys_as_string(Article.__struct__()))
      |> remap_for_atoms_and_nil_values()
    end)
  end

  # zamiana kluczy na atomy + wyeliminowanie pustych wartości
  defp remap_for_atoms_and_nil_values(map) do
    map
    |> Map.new(fn {k, v} ->
      if !v do
        if k == :published_date,
          do: {String.to_atom(k), ~N(1960-01-01 00:00:00)},
          else: {String.to_atom(k), "null"}
      else
        {String.to_atom(k), v}
      end
    end)
  end
end
