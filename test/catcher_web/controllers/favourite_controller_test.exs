defmodule CatcherWeb.FavouriteControllerTest do
  use CatcherWeb.ConnCase

  alias Catcher.Account
  alias Catcher.Account.Favourite

  @create_attrs %{
    comment: "some comment"
  }
  @update_attrs %{
    comment: "some updated comment"
  }
  @invalid_attrs %{comment: nil}

  def fixture(:favourite) do
    {:ok, favourite} = Account.create_favourite(@create_attrs)
    favourite
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all favourites", %{conn: conn} do
      conn = get(conn, Routes.favourite_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create favourite" do
    test "renders favourite when data is valid", %{conn: conn} do
      conn = post(conn, Routes.favourite_path(conn, :create), favourite: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.favourite_path(conn, :show, id))

      assert %{
               "id" => id,
               "comment" => "some comment"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.favourite_path(conn, :create), favourite: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update favourite" do
    setup [:create_favourite]

    test "renders favourite when data is valid", %{conn: conn, favourite: %Favourite{id: id} = favourite} do
      conn = put(conn, Routes.favourite_path(conn, :update, favourite), favourite: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.favourite_path(conn, :show, id))

      assert %{
               "id" => id,
               "comment" => "some updated comment"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, favourite: favourite} do
      conn = put(conn, Routes.favourite_path(conn, :update, favourite), favourite: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete favourite" do
    setup [:create_favourite]

    test "deletes chosen favourite", %{conn: conn, favourite: favourite} do
      conn = delete(conn, Routes.favourite_path(conn, :delete, favourite))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.favourite_path(conn, :show, favourite))
      end
    end
  end

  defp create_favourite(_) do
    favourite = fixture(:favourite)
    %{favourite: favourite}
  end
end
