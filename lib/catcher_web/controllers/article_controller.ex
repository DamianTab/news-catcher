defmodule CatcherWeb.ArticleController do
  use CatcherWeb, :controller

  alias Catcher.News
  alias Catcher.News.Article

  action_fallback CatcherWeb.FallbackController

  def index(conn, params) do
    pageable = News.list_articles(params)
    render(conn, "index.json", pageable: pageable)
  end

  # def create(conn, %{"article" => article_params}) do
  #   with {:ok, %Article{} = article} <- News.create_article(article_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", Routes.article_path(conn, :show, article))
  #     |> render("show.json", article: article)
  #   end
  # end

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
      News.delete_all_articles
      send_resp(conn, :no_content, "")
  end

end
