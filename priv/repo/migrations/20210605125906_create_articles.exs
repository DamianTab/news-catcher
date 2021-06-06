defmodule Catcher.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :summary, :text
      add :country, :string
      add :author, :string
      add :link, :text
      add :language, :string
      add :media, :text
      add :title, :text
      add :rights, :string
      add :topic, :string
      add :published_date, :naive_datetime

      timestamps()
    end

  end
end
