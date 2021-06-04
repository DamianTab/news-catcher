defmodule CatcherWeb.UserController do
  use CatcherWeb, :controller

  alias Catcher.Account
  alias Catcher.Account.User

  action_fallback CatcherWeb.FallbackController

  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, _params) do
    {:ok, %User{} = user} = Account.create_user()
    conn
    |> put_status(:created)
    |> put_resp_header("location", Routes.user_path(conn, :show, user))
    |> render("show.json", user: user)
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => %{"email" => _email, "nick" => _nick} = user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def patch(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
