defmodule Catcher.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :page, :integer
      add :page_size, :integer
      add :query, :string
      add :lang, :string
      add :sort_by, :string
      add :from, :naive_datetime
      add :to, :naive_datetime
      add :topic, :string
      add :sources, :string

      add :pagination, :text

      timestamps()
    end

  end
end
