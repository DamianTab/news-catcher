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
end
