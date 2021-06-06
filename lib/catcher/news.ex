defmodule Catcher.News do
  @moduledoc """
  The News context.
  """

  import Ecto.Query, warn: false
  alias Catcher.Repo

  alias Catcher.News.Article

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles(params) do
    Repo.pagination_query(Article, params)
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id), do: Repo.get!(Article, id)

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{data: %Article{}}

  """
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def delete_all_articles do
    Repo.delete_all(Article)
  end

  def create_article!(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert!()
  end

  def create_articles!(articles_data) do
    articles_data
    |> Enum.map(fn raw_data ->
      case check_article_duplicate(raw_data) do
        nil ->
          create_article!(raw_data)
        article_from_db ->
          article_from_db
      end

    end)
  end

  defp check_article_duplicate(raw_data) do
    Repo.one(
        Article
        |> where([a],
          a.author == ^raw_data.author and
          a.country == ^raw_data.country and
          a.language == ^raw_data.language and
          a.link == ^raw_data.link and
          a.published_date == ^raw_data.published_date and
          a.rights == ^raw_data.rights and
          a.summary == ^raw_data.summary and
          a.title == ^raw_data.title and
          a.topic == ^raw_data.topic)
        |> select([a], a)
      )
  end
end
