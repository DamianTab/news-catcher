defmodule CatcherWeb.ArticleControllerTest do
  use CatcherWeb.ConnCase

  alias Catcher.News
  alias Catcher.News.Article

  @create_attrs %{
    author: "some author",
    country: "some country",
    language: "some language",
    link: "some link",
    media: "some media",
    published_date: ~N[2010-04-17 14:00:00],
    rights: "some rights",
    summary: "some summary",
    title: "some title",
    topic: "some topic"
  }
  @update_attrs %{
    author: "some updated author",
    country: "some updated country",
    language: "some updated language",
    link: "some updated link",
    media: "some updated media",
    published_date: ~N[2011-05-18 15:01:01],
    rights: "some updated rights",
    summary: "some updated summary",
    title: "some updated title",
    topic: "some updated topic"
  }
  @invalid_attrs %{author: nil, country: nil, language: nil, link: nil, media: nil, published_date: nil, rights: nil, summary: nil, title: nil, topic: nil}

  def fixture(:article) do
    {:ok, article} = News.create_article(@create_attrs)
    article
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all articles", %{conn: conn} do
      conn = get(conn, Routes.article_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create article" do
    test "renders article when data is valid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), article: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.article_path(conn, :show, id))

      assert %{
               "id" => id,
               "author" => "some author",
               "country" => "some country",
               "language" => "some language",
               "link" => "some link",
               "media" => "some media",
               "published_date" => "2010-04-17T14:00:00",
               "rights" => "some rights",
               "summary" => "some summary",
               "title" => "some title",
               "topic" => "some topic"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.article_path(conn, :create), article: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update article" do
    setup [:create_article]

    test "renders article when data is valid", %{conn: conn, article: %Article{id: id} = article} do
      conn = put(conn, Routes.article_path(conn, :update, article), article: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.article_path(conn, :show, id))

      assert %{
               "id" => id,
               "author" => "some updated author",
               "country" => "some updated country",
               "language" => "some updated language",
               "link" => "some updated link",
               "media" => "some updated media",
               "published_date" => "2011-05-18T15:01:01",
               "rights" => "some updated rights",
               "summary" => "some updated summary",
               "title" => "some updated title",
               "topic" => "some updated topic"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, article: article} do
      conn = put(conn, Routes.article_path(conn, :update, article), article: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete article" do
    setup [:create_article]

    test "deletes chosen article", %{conn: conn, article: article} do
      conn = delete(conn, Routes.article_path(conn, :delete, article))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.article_path(conn, :show, article))
      end
    end
  end

  defp create_article(_) do
    article = fixture(:article)
    %{article: article}
  end
end
