defmodule CatcherWeb.RequestView do
  use CatcherWeb, :view
  alias CatcherWeb.RequestView

  def render("index.json", %{pageable: {requests, page}}) do
    %{data: render_many(requests, RequestView, "request.json"), pagination: page}
  end

  def render("show.json", %{request: request}) do
    %{data: render_one(request, RequestView, "request.json")}
  end

  def render("request.json", %{request: request}) do
    %{id: request.id,
      page: request.page,
      page_size: request.page_size,
      query: request.query,
      lang: request.lang,
      sort_by: request.sort_by,
      from: request.from,
      to: request.to,
      topic: request.topic,
      sources: request.sources}
  end

  def stale_checks("show." <> _format, %{request: data}) do
    [etag: PhoenixETag.schema_etag(data),
      last_modified: PhoenixETag.schema_last_modified(data)]
  end

end
