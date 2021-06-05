defmodule Catcher.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :summary, :string
      add :country, :string
      add :author, :string
      add :link, :string
      add :language, :string
      add :media, :string
      add :title, :string
      add :rights, :string
      add :topic, :string
      add :published_date, :naive_datetime

      timestamps()
    end

  end
end
