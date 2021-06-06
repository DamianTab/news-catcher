defmodule CatcherWeb.FavouriteView do
  use CatcherWeb, :view
  alias CatcherWeb.FavouriteView

  def render("index.json", %{favourites: {favourites, page}}) do
    %{data: render_many(favourites, FavouriteView, "favourite.json"), pagination: page}
  end

  def render("show.json", %{favourite: favourite}) do
    %{data: render_one(favourite, FavouriteView, "favourite.json")}
  end

  def render("favourite.json", %{favourite: favourite}) do
    %{id: favourite.id,
      user_id: favourite.user_id,
      article_id: favourite.article_id,
      comment: favourite.comment}
  end

  # ETAG LIBRARY
  def stale_checks("show." <> _format, %{favourite: data}) do
    [etag: PhoenixETag.schema_etag(data),
      last_modified: PhoenixETag.schema_last_modified(data)]
  end
end
