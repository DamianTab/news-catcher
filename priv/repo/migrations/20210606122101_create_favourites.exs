defmodule Catcher.Repo.Migrations.CreateFavourites do
  use Ecto.Migration

  def change do
    create table(:favourites) do
      add :comment, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :article_id, references(:articles, on_delete: :delete_all)

      timestamps()
    end

    create index(:favourites, [:user_id])
    create index(:favourites, [:article_id])
    create unique_index(:favourites, [:user_id, :article_id])
  end
end
