defmodule CatcherWeb.MigrationView do
  use CatcherWeb, :view
  alias CatcherWeb.MigrationView

  def render("index.json", %{migrations: migrations}) do
    %{data: render_many(migrations, MigrationView, "migration.json")}
  end

  def render("show.json", %{migration: migration}) do
    %{data: render_one(migration, MigrationView, "migration.json")}
  end

  def render("migration.json", %{migration: migration}) do
    %{id: migration.id}
  end
end
