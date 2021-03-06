defmodule CatcherWeb.FavouriteController do
  use CatcherWeb, :controller

  alias Catcher.Account
  alias Catcher.Account.Favourite

  action_fallback CatcherWeb.FallbackController

  def index(conn, %{"uid" => _uid} = params) do
    favourites = Account.list_favourites(params)
    render(conn, "index.json", favourites: favourites)
  end

  def create(conn, %{"uid" => uid}) do
    {:ok, %Favourite{} = favourite} = Account.create_favourite(%{"user_id" => uid})
    conn
    |> put_status(:created)
    |> put_resp_header("location", Routes.favourite_path(conn, :show, uid, favourite))
    |> render("show.json", favourite: favourite)
  end

  def show(conn, %{"id" => id, "uid" => uid}) do
    favourite = Account.get_favourite_with_user!(id, uid)
    PhoenixETag.render_if_stale(conn, "show.json", favourite: favourite)
  end

  def update(conn, %{"fid" => fid, "uid" => uid, "favourite" => %{"article_id" => article_id, "comment" => comment}}) do
    params = %{"fid" => fid, "uid" => uid, "favourite" => %{"article_id" => article_id, "comment" => comment}}
    case Account.exist_favourite_by_article?(uid, article_id) do
      true ->
        conn
        |> put_status(:bad_request)
        |> put_view(CatcherWeb.ErrorView)
        |> render("article_already_in_favourties.json")
      false ->
        update_favourite(conn, params)
    end
  end

  def patch(conn, %{"fid" => fid, "uid" => uid, "favourite" => %{"comment" => comment}}) do
    params = %{"fid" => fid, "uid" => uid, "favourite" => %{"comment" => comment}}
    update_favourite(conn, params)
  end

  def delete(conn, %{"id" => id, "uid" => uid}) do
    favourite = Account.get_favourite_with_user!(id, uid)

    with {:ok, %Favourite{}} <- Account.delete_favourite(favourite) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete_all(conn, %{"uid" => _uid} = params) do
    Account.delete_all_favourite(params)
    send_resp(conn, :no_content, "")
  end

  defp update_favourite(conn, %{"fid" => fid, "uid" => uid, "favourite" => favourite_params}) do
    favourite = Account.get_favourite_with_user!(fid, uid)

    case CatcherWeb.EtagHelper.etag_matches?(conn, favourite) do
      false -> send_resp(conn, :precondition_failed, "")
      true ->
        with {:ok, %Favourite{} = favourite} <- Account.update_favourite(favourite, favourite_params) do
          PhoenixETag.render_if_stale(conn, "show.json", favourite: favourite)
        end
    end
  end

end
