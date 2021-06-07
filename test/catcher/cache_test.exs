defmodule Catcher.CacheTest do
  use Catcher.DataCase

  alias Catcher.Cache

  describe "requests" do
    alias Catcher.Cache.Request

    @valid_attrs %{from: ~N[2010-04-17 14:00:00], lang: "some lang", page: 42, page_size: 42, query: "some query", sort_by: "some sort_by", sources: "some sources", to: ~N[2010-04-17 14:00:00], topic: "some topic"}
    @update_attrs %{from: ~N[2011-05-18 15:01:01], lang: "some updated lang", page: 43, page_size: 43, query: "some updated query", sort_by: "some updated sort_by", sources: "some updated sources", to: ~N[2011-05-18 15:01:01], topic: "some updated topic"}
    @invalid_attrs %{from: nil, lang: nil, page: nil, page_size: nil, query: nil, sort_by: nil, sources: nil, to: nil, topic: nil}

    def request_fixture(attrs \\ %{}) do
      {:ok, request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Cache.create_request()

      request
    end

    test "list_requests/0 returns all requests" do
      request = request_fixture()
      assert Cache.list_requests() == [request]
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()
      assert Cache.get_request!(request.id) == request
    end

    test "create_request/1 with valid data creates a request" do
      assert {:ok, %Request{} = request} = Cache.create_request(@valid_attrs)
      assert request.from == ~N[2010-04-17 14:00:00]
      assert request.lang == "some lang"
      assert request.page == 42
      assert request.page_size == 42
      assert request.query == "some query"
      assert request.sort_by == "some sort_by"
      assert request.sources == "some sources"
      assert request.to == ~N[2010-04-17 14:00:00]
      assert request.topic == "some topic"
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cache.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()
      assert {:ok, %Request{} = request} = Cache.update_request(request, @update_attrs)
      assert request.from == ~N[2011-05-18 15:01:01]
      assert request.lang == "some updated lang"
      assert request.page == 43
      assert request.page_size == 43
      assert request.query == "some updated query"
      assert request.sort_by == "some updated sort_by"
      assert request.sources == "some updated sources"
      assert request.to == ~N[2011-05-18 15:01:01]
      assert request.topic == "some updated topic"
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = Cache.update_request(request, @invalid_attrs)
      assert request == Cache.get_request!(request.id)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = Cache.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> Cache.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = Cache.change_request(request)
    end
  end
end
