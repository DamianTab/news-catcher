defmodule Catcher.Cache do
  @moduledoc """
  The Cache context.
  """

  import Ecto.Query, warn: false
  alias Catcher.Repo

  alias Catcher.Cache.Request

  @doc """
  Returns the list of requests.

  ## Examples

      iex> list_requests()
      [%Request{}, ...]

  """
  def list_requests(params) do
    {requests, page} = Repo.pagination_query(Request, params)
    requests = Repo.preload(requests, :articles)
    {requests, page}
  end

  @doc """
  Gets a single request.

  Raises `Ecto.NoResultsError` if the Request does not exist.

  ## Examples

      iex> get_request!(123)
      %Request{}

      iex> get_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_request!(id), do: Repo.get!(Request, id) |> Repo.preload(:articles)

  @doc """
  Creates a request.

  ## Examples

      iex> create_request(%{field: value})
      {:ok, %Request{}}

      iex> create_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_request(attrs \\ %{}) do
    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert()
    |> Repo.preload(:articles)
  end

  @doc """
  Updates a request.

  ## Examples

      iex> update_request(request, %{field: new_value})
      {:ok, %Request{}}

      iex> update_request(request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_request(%Request{} = request, attrs) do
    request
    |> Request.changeset(attrs)
    |> Repo.update()
    |> Repo.preload(:articles)
  end

  @doc """
  Deletes a request.

  ## Examples

      iex> delete_request(request)
      {:ok, %Request{}}

      iex> delete_request(request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_request(%Request{} = request) do
    Repo.delete(request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking request changes.

  ## Examples

      iex> change_request(request)
      %Ecto.Changeset{data: %Request{}}

  """
  def change_request(%Request{} = request, attrs \\ %{}) do
    Request.changeset(request, attrs)
  end

  def delete_all_requests do
    Repo.delete_all(Request)
  end

  def insert_with_articles!(request_struct, articles, page) do
    page = Map.replace!(page, :mode, "cache")

    %{request_struct | pagination: Jason.encode!(page)}
    |> Repo.insert!()
    |> Repo.preload(:articles)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:articles, articles)
    |> Catcher.Repo.update!()
    |> Catcher.Repo.preload(:articles)

  end

  def get_by_fields_values(fake_request) do
    Repo.one(
      Request
      |> where([r],
      r.from == ^fake_request.from and
      r.lang == ^fake_request.lang and
      r.page == ^fake_request.page and
      r.page_size == ^fake_request.page_size and
      r.query == ^fake_request.query and
      r.sort_by == ^fake_request.sort_by and
      r.sources == ^fake_request.sources and
      r.to == ^fake_request.to and
      r.topic == ^fake_request.topic)
      |> select([r], r)
    )

    # todo preload kiedy nie nul
    # |> Repo.preload(:articles)
  end
end
