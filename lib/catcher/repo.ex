defmodule Catcher.Repo do
  use Ecto.Repo,
    otp_app: :catcher,
    adapter: Ecto.Adapters.Postgres
  use Phoenix.Pagination, per_page: 5

  def pagination_query(schema, params) do
    paginate(schema, params)
    |> Catcher.Page.prepare()
  end
end
