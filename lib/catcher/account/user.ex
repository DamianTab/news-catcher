defmodule Catcher.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :nick, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :nick])
    |> validate_required([:email, :nick])
    |> unique_constraint(:email)
  end
end
