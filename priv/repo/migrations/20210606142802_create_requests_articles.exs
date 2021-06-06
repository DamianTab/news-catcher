defmodule Catcher.Repo.Migrations.CreateRequestsArticles do
  use Ecto.Migration

  def change do
    create table(:requests_articles) do
      add :request_id, references(:requests, on_delete: :delete_all)
      add :article_id, references(:articles, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:requests_articles, [:request_id, :article_id])
  end
end
