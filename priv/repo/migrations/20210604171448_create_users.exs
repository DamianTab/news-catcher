defmodule Catcher.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :nick, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
