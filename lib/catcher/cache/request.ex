defmodule Catcher.Cache.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :from, :naive_datetime
    field :lang, :string
    field :page, :integer
    field :page_size, :integer
    field :query, :string
    field :sort_by, :string
    field :sources, :string
    field :to, :naive_datetime
    field :topic, :string

    many_to_many :articles, Catcher.News.Article, join_through: "requests_articles"

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:page, :page_size, :query, :lang, :sort_by, :from, :to, :topic, :sources])
    |> validate_required([:query])
  end
end
