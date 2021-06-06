defmodule CatcherWeb.ArticleController do
  use CatcherWeb, :controller
  alias Catcher.News
  alias Catcher.News.{Article, ArticleSearchParams, HttpClient, ArticleParser, ParamsMapper, ParamsHelper}
  alias Catcher.Cache

  action_fallback CatcherWeb.FallbackController

  def index(conn, params) do
    case find_search_engine_param(params) do
      nil ->
        index_from_database(conn, params)

      _search_query_param ->
        index_from_search_engine(conn, params)
    end
  end

  def index_params(conn, _params) do
    article_search_params = ArticleSearchParams.default_values()
    Jason.encode!(article_search_params)
    send_resp(conn, 200, Jason.encode!(article_search_params, pretty: true))
  end

  def show(conn, %{"id" => id}) do
    article = News.get_article!(id)
    PhoenixETag.render_if_stale(conn, "show.json", article: article)
  end

  def delete(conn, %{"id" => id}) do
    article = News.get_article!(id)

    with {:ok, %Article{}} <- News.delete_article(article) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete_all(conn, _params) do
    News.delete_all_articles()
    send_resp(conn, :no_content, "")
  end

  defp find_search_engine_param(params) do
    filtered_article_params = ArticleSearchParams.unique_string_keys()

    Map.keys(params)
    |> Enum.find(fn key -> key in filtered_article_params end)
  end

  defp index_from_database(conn, params) do
    pageable = News.list_articles(params)
    render(conn, "index.json", pageable: pageable)
  end

  defp index_from_search_engine(conn, params) do
    if ParamsHelper.param_exist_and_not_empty?("query", params) do
      efficient_params = ParamsMapper.generate_query_params(params)
      params_as_request_fields = ParamsMapper.map_params_for_request_structure(efficient_params)
      fake_request = struct!(Catcher.Cache.Request, params_as_request_fields)

      case Cache.get_by_fields_values(fake_request) do
        nil ->
          search_in_external_api(conn, efficient_params, fake_request)

        request ->
          render(conn, "index.json", pageable: {request.articles, Jason.decode!(request.pagination)})
      end

    else
      conn
      |> put_status(:bad_request)
      |> put_view(CatcherWeb.ErrorView)
      |> render("missing_search_query.json")
    end
  end

  defp search_in_external_api(conn, efficient_params, request_structure) do
    case HttpClient.search_articles(efficient_params) do
      {:ok, body} ->
        {articles_raw_data, page} = ArticleParser.parse(body)
        articles = News.create_articles!(articles_raw_data)
        Cache.insert_with_articles!(request_structure, articles, page)
        render(conn, "index.json", pageable: {articles, page})

      {:error, message} ->
        conn
        |> put_status(:internal_server_error)
        |> put_view(CatcherWeb.ErrorView)
        |> render("search_engine_error.json", message: message)
    end
  end

end
