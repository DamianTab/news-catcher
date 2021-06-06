defmodule CatcherWeb.FavouriteController do
  use CatcherWeb, :controller

  alias Catcher.Account
  alias Catcher.Account.Favourite

  action_fallback CatcherWeb.FallbackController

  def index(conn, %{"uid" => uid} = params) do
    favourites = Account.list_favourites(params)
    render(conn, "index.json", favourites: favourites)
  end

  def create(conn, %{"uid" => uid} = params) do
    {:ok, %Favourite{} = favourite} = Account.create_favourite()
    conn
    |> put_status(:created)
    |> put_resp_header("location", Routes.favourite_path(conn, :show, uid, favourite))
    |> render("show.json", favourite: favourite)
  end

  def show(conn, %{"id" => id}) do
    favourite = Account.get_favourite!(id)
    render(conn, "show.json", favourite: favourite)
  end

  def update(conn, %{"fid" => _fid, "favourite" => %{"user_id" => _user_id, "article_id" => _article_id, "comment" => _comment}} = params) do
    update_favourite(conn, params)
  end

  def patch(conn, %{"fid" => _fid, "favourite" => %{"comment" => _comment}} = params) do
    update_favourite(conn, params)
  end

  def delete(conn, %{"id" => id}) do
    favourite = Account.get_favourite!(id)

    with {:ok, %Favourite{}} <- Account.delete_favourite(favourite) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete_all(conn, %{"uid" => uid} = params) do
    Account.delete_all_favourite(params)
    send_resp(conn, :no_content, "")
  end

  defp update_favourite(conn, %{"fid" => fid, "favourite" => favourite_params}) do
    favourite = Account.get_favourite!(fid)

    case CatcherWeb.EtagHelper.etag_matches?(conn, favourite) do
      false -> send_resp(conn, :precondition_failed, "")
      true ->
        with {:ok, %Favourite{} = favourite} <- Account.update_favourite(favourite, favourite_params) do
          PhoenixETag.render_if_stale(conn, "show.json", favourite: favourite)
        end
    end
  end

end
