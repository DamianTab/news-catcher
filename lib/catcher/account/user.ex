defmodule Catcher.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:email, :nick]}
  schema "users" do
    field :email, :string, default: "null"
    field :nick, :string, default: "null"

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :nick])
    |> validate_required([:email, :nick])
  end
end
