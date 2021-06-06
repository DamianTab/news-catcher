defmodule Catcher.News.HttpClient do
  alias Catcher.News.ArticleSearchParams

  @api_url ~s(https://newscatcher.p.rapidapi.com/v1/search)

  def search_articles(params) do
    headers = ["x-rapidapi-key": ArticleSearchParams.default_values.x_rapidAPI_key]
    options = [params: params]
    execute_request(@api_url, headers, options)
  end

  defp execute_request(url, headers, options) do
    case HTTPoison.get(url, headers, options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: 429}} ->
        {:error, "Too many request on search engine - limit exceeded. Try again in an hour."}

      {:ok, %HTTPoison.Response{status_code: 403}} ->
        {:error, "Forbidden request. Page is limited to 20 and page_size to 5."}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found search engine resource."}

      {:ok, %HTTPoison.Response{status_code: _, body: body}} ->
        raise body
        {:error, "Unknown error on search engine - contact developer."}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
