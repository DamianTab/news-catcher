defmodule CatcherWeb.UserController do
  use CatcherWeb, :controller

  alias Catcher.Account
  alias Catcher.Account.User

  action_fallback CatcherWeb.FallbackController

  def index(conn, params) do
    pageable = Account.list_users(params)
    render(conn, "index.json", pageable: pageable)
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
    PhoenixETag.render_if_stale(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => _id, "user" => %{"email" => _email, "nick" => _nick}} = params ) do
    update_user(conn, params)
  end

  def patch(conn, %{"id" => _id, "user" => _user_params} = params) do
    update_user(conn, params)
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  defp update_user(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    case CatcherWeb.EtagHelper.etag_matches?(conn, user) do
      false -> send_resp(conn, :precondition_failed, "")
      true ->
        with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
          PhoenixETag.render_if_stale(conn, "show.json", user: user)
        end
    end
  end

end
