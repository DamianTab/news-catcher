defmodule CatcherWeb.ErrorView do
  use CatcherWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".

  def render("missing_search_query.json", _assigns) do
    %{errors: %{detail: "Missing query param"}}
  end

  def render("article_already_in_favourties.json", _assigns) do
    %{errors: %{detail: "This user already has this article in favourites."}}
  end

  def render("search_engine_error.json", %{message: message}) do
    %{errors: %{detail: message}}
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
