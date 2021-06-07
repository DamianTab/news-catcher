defmodule Catcher.Cache.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :from, :naive_datetime
    field :lang, :string, default: "null"
    field :page, :integer, default: 1
    field :page_size, :integer, default: 5
    field :query, :string
    field :sort_by, :string, default: "null"
    field :sources, :string, default: "null"
    field :to, :naive_datetime
    field :topic, :string, default: "null"

    field :pagination, :string, default: "null"
    many_to_many :articles, Catcher.News.Article, join_through: "requests_articles"

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:page, :page_size, :query, :lang, :sort_by, :from, :to, :topic, :sources])
    |> validate_required([:page, :page_size, :query, :lang, :sort_by, :from, :to, :topic, :sources])
  end
end
