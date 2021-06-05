defmodule Catcher.News.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :author, :string
    field :country, :string
    field :language, :string
    field :link, :string
    field :media, :string
    field :published_date, :naive_datetime
    field :rights, :string
    field :summary, :string
    field :title, :string
    field :topic, :string

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:summary, :country, :author, :link, :language, :media, :title, :rights, :topic, :published_date])
    |> validate_required([:summary, :country, :author, :link, :language, :media, :title, :rights, :topic, :published_date])
  end
end
