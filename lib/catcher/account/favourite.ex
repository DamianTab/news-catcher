defmodule Catcher.Account.Favourite do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favourites" do
    field :comment, :string, default: "null"
    field :user_id, :id
    field :article_id, :id

    timestamps()
  end

  @doc false
  def changeset(favourite, attrs) do
    favourite
    |> cast(attrs, [:user_id, :article_id, :comment])
    |> validate_required([:comment])
  end
end
