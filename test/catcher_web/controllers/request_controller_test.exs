defmodule CatcherWeb.RequestControllerTest do
  use CatcherWeb.ConnCase

  alias Catcher.Cache
  alias Catcher.Cache.Request

  @create_attrs %{
    from: ~N[2010-04-17 14:00:00],
    lang: "some lang",
    page: 42,
    page_size: 42,
    query: "some query",
    sort_by: "some sort_by",
    sources: "some sources",
    to: ~N[2010-04-17 14:00:00],
    topic: "some topic"
  }
  @update_attrs %{
    from: ~N[2011-05-18 15:01:01],
    lang: "some updated lang",
    page: 43,
    page_size: 43,
    query: "some updated query",
    sort_by: "some updated sort_by",
    sources: "some updated sources",
    to: ~N[2011-05-18 15:01:01],
    topic: "some updated topic"
  }
  @invalid_attrs %{from: nil, lang: nil, page: nil, page_size: nil, query: nil, sort_by: nil, sources: nil, to: nil, topic: nil}

  def fixture(:request) do
    {:ok, request} = Cache.create_request(@create_attrs)
    request
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all requests", %{conn: conn} do
      conn = get(conn, Routes.request_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create request" do
    test "renders request when data is valid", %{conn: conn} do
      conn = post(conn, Routes.request_path(conn, :create), request: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.request_path(conn, :show, id))

      assert %{
               "id" => id,
               "from" => "2010-04-17T14:00:00",
               "lang" => "some lang",
               "page" => 42,
               "page_size" => 42,
               "query" => "some query",
               "sort_by" => "some sort_by",
               "sources" => "some sources",
               "to" => "2010-04-17T14:00:00",
               "topic" => "some topic"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.request_path(conn, :create), request: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update request" do
    setup [:create_request]

    test "renders request when data is valid", %{conn: conn, request: %Request{id: id} = request} do
      conn = put(conn, Routes.request_path(conn, :update, request), request: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.request_path(conn, :show, id))

      assert %{
               "id" => id,
               "from" => "2011-05-18T15:01:01",
               "lang" => "some updated lang",
               "page" => 43,
               "page_size" => 43,
               "query" => "some updated query",
               "sort_by" => "some updated sort_by",
               "sources" => "some updated sources",
               "to" => "2011-05-18T15:01:01",
               "topic" => "some updated topic"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, request: request} do
      conn = put(conn, Routes.request_path(conn, :update, request), request: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete request" do
    setup [:create_request]

    test "deletes chosen request", %{conn: conn, request: request} do
      conn = delete(conn, Routes.request_path(conn, :delete, request))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.request_path(conn, :show, request))
      end
    end
  end

  defp create_request(_) do
    request = fixture(:request)
    %{request: request}
  end
end
