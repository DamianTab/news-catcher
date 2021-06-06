defmodule CatcherWeb.MigrationController do
  use CatcherWeb, :controller

  alias Catcher.Account
  alias Catcher.Account.Migration

  action_fallback CatcherWeb.FallbackController

  def migration(conn, %{"user1" => user1, "user2" => user2}) do
    Account.migrate_users(user1, user2)
    send_resp(conn, :ok, "")
  end

end
