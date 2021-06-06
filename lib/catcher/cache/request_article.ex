defmodule Catcher.Cache.RequestArticle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests_articles" do
    field :request_id, :id
    field :article_id, :id

    timestamps()
  end

  @doc false
  def changeset(request_article, attrs) do
    request_article
    |> cast(attrs, [])
    |> validate_required([])
  end
end
