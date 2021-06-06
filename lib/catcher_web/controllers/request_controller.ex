defmodule CatcherWeb.RequestController do
  use CatcherWeb, :controller

  alias Catcher.Cache
  alias Catcher.Cache.Request

  action_fallback CatcherWeb.FallbackController

  def index(conn, params) do
    pageable = Cache.list_requests(params)
    render(conn, "index.json", pageable: pageable)
  end

  def show(conn, %{"id" => id}) do
    request = Cache.get_request!(id)
    PhoenixETag.render_if_stale(conn, "show.json", request: request)
  end
  def delete(conn, %{"id" => id}) do
    request = Cache.get_request!(id)

    with {:ok, %Request{}} <- Cache.delete_request(request) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete_all(conn, _params) do
    Cache.delete_all_requests()
    send_resp(conn, :no_content, "")
  end
end
