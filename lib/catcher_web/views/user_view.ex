defmodule CatcherWeb.UserView do
  use CatcherWeb, :view
  alias CatcherWeb.UserView

  def render("index.json", %{pageable: {users, page}}) do
    %{data: render_many(users, UserView, "user.json"), pagination: page}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      nick: user.nick}
  end

  # ETAG LIBRARY
  def stale_checks("show." <> _format, %{user: data}) do
    [etag: PhoenixETag.schema_etag(data),
      last_modified: PhoenixETag.schema_last_modified(data)]
  end

end
