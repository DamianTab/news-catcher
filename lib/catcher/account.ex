defmodule Catcher.Account do
  @moduledoc """
  The Account context.
  """
  require Logger
  import Ecto.Query, warn: false
  alias Catcher.Repo

  alias Catcher.Account.User

  # in seconds
  @delete_outdated_data -120

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users(params) do
    Repo.pagination_query(User, params)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias Catcher.Account.Favourite

  @doc """
  Returns the list of favourites.

  ## Examples

      iex> list_favourites()
      [%Favourite{}, ...]

  """
  def list_favourites(%{"uid" => uid} = params) do
    Repo.pagination_query((Favourite
      |> where([f], f.user_id == ^uid)), params)
  end

  @doc """
  Gets a single favourite.

  Raises `Ecto.NoResultsError` if the Favourite does not exist.

  ## Examples

      iex> get_favourite!(123)
      %Favourite{}

      iex> get_favourite!(456)
      ** (Ecto.NoResultsError)

  """
  def get_favourite!(id) do
    Repo.get!(Favourite, id)
  end


  def get_favourite_with_user!(id, uid) do
      Repo.get!(Favourite
        |> where([f], f.user_id == ^uid), id)
  end

  @doc """
  Creates a favourite.

  ## Examples

      iex> create_favourite(%{field: value})
      {:ok, %Favourite{}}

      iex> create_favourite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_favourite(attrs \\ %{}) do
    %Favourite{}
    |> Favourite.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a favourite.

  ## Examples

      iex> update_favourite(favourite, %{field: new_value})
      {:ok, %Favourite{}}

      iex> update_favourite(favourite, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_favourite(%Favourite{} = favourite, attrs) do
    favourite
    |> Favourite.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a favourite.

  ## Examples

      iex> delete_favourite(favourite)
      {:ok, %Favourite{}}

      iex> delete_favourite(favourite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_favourite(%Favourite{} = favourite) do
    Repo.delete(favourite)
  end


  def delete_all_favourite(%{"uid" => uid}) do
    Repo.delete_all((Favourite
               |> where([f], f.user_id == ^uid)))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking favourite changes.

  ## Examples

      iex> change_favourite(favourite)
      %Ecto.Changeset{data: %Favourite{}}

  """
  def change_favourite(%Favourite{} = favourite, attrs \\ %{}) do
    Favourite.changeset(favourite, attrs)
  end

  def migrate_users(user1, user2) do
    favourites_user1 = Repo.all(Favourite
                                |> where([f], f.user_id == ^user1))
    favourites_user2 = Repo.all(Favourite
            |> where([f], f.user_id == ^user2))

    for favourite <- favourites_user2 do
      fav_tmp = Enum.find(favourites_user1, &(&1.article_id == favourite.article_id))
      if fav_tmp do
        delete_favourite(fav_tmp)
      end
      update_favourite(favourite, %{"user_id" => user1})
    end
    delete_user(get_user!(user2))
  end

  def exist_favourite_by_article?(uid, article_id) do
    Repo.exists?(Favourite
    |> where([f], f.user_id == ^uid and f.article_id == ^article_id))
  end


  def clean_users do
    default_user = %User{}
    delete_from_date = NaiveDateTime.add(NaiveDateTime.utc_now() , @delete_outdated_data)

    {count, id_list} = Repo.delete_all(User
    |> select([u], u.id)
    |> where([u], u.email == ^default_user.email
      and u.nick == ^default_user.nick
      and u.inserted_at == u.updated_at
      and u.inserted_at < ^delete_from_date)
    )
    Logger.info  "Database Garbage Collector - Deleted #{inspect(count)} users with id: #{inspect(id_list, charlists: :as_lists)}"
  end

  def clean_favourites do
    default_favourite = %Favourite{}
    delete_from_date = NaiveDateTime.add(NaiveDateTime.utc_now() , @delete_outdated_data)

    {count, id_list} = Repo.delete_all(Favourite
    |> select([f], f.id)
    |> where([f], is_nil(f.article_id)
      and f.comment == ^default_favourite.comment
      and f.inserted_at == f.updated_at
      and f.inserted_at < ^delete_from_date)
    )
    Logger.info  "Database Garbage Collector - Deleted #{inspect(count)} favourites with id: #{inspect(id_list, charlists: :as_lists)}"
  end

end
