defmodule Catcher.Repo do
  use Ecto.Repo,
    otp_app: :catcher,
    adapter: Ecto.Adapters.Postgres
end
