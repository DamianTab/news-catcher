defmodule CatcherWeb.MigrationControllerTest do
  use CatcherWeb.ConnCase

  alias Catcher.Account
  alias Catcher.Account.Migration

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:migration) do
    {:ok, migration} = Account.create_migration(@create_attrs)
    migration
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all migrations", %{conn: conn} do
      conn = get(conn, Routes.migration_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create migration" do
    test "renders migration when data is valid", %{conn: conn} do
      conn = post(conn, Routes.migration_path(conn, :create), migration: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.migration_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.migration_path(conn, :create), migration: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update migration" do
    setup [:create_migration]

    test "renders migration when data is valid", %{conn: conn, migration: %Migration{id: id} = migration} do
      conn = put(conn, Routes.migration_path(conn, :update, migration), migration: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.migration_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, migration: migration} do
      conn = put(conn, Routes.migration_path(conn, :update, migration), migration: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete migration" do
    setup [:create_migration]

    test "deletes chosen migration", %{conn: conn, migration: migration} do
      conn = delete(conn, Routes.migration_path(conn, :delete, migration))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.migration_path(conn, :show, migration))
      end
    end
  end

  defp create_migration(_) do
    migration = fixture(:migration)
    %{migration: migration}
  end
end
