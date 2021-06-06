defmodule Catcher.News.HttpClient do
  alias Catcher.News.ArticleSearchParams

  @api_url ~s(https://newscatcher.p.rapidapi.com/v1/search)

  def search_articles(params) do
    headers = ["x-rapidapi-key": ArticleSearchParams.default_values.x_rapidAPI_key]
    options = [params: generate_query_params(params)]
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

  defp generate_query_params(params) do
    params
      |> Map.update("from", ArticleSearchParams.default_values.from, fn old_value -> old_value end)
      |> Map.update("to", NaiveDateTime.to_string(NaiveDateTime.local_now()), fn old_value -> old_value end)
      |> Map.update("lang", "", fn old_value ->
         if old_value not in ArticleSearchParams.default_values.lang do "" end
        end)
      |> Map.update("sort_by", "", fn old_value ->
         if old_value not in ArticleSearchParams.default_values.sort_by do "" end
        end)
      |> Map.update("topic", "", fn old_value ->
         if old_value not in ArticleSearchParams.default_values.topic do "" end
        end)
      # filtrowanie pustych paramsów
      |> Enum.filter(fn {_key, value} -> ArticleSearchParams.query_param_not_empty?(value) end)
      # filtrowanie żeby nie było jakiś dziwnych paramsów (tylko te zdefiniowane)
      |> Enum.filter(fn {key, _value} -> key in ArticleSearchParams.valid_string_keys() end)
      # zamiana query na q
      |> Enum.map(fn {key, value} ->
          case key do
            "query" ->
              {"q", value}
            _any_param ->
              {key, value}
          end
        end)
      |> Map.new()
      # Należy dodać ponieważ to zawsze będzie występować i nie ma tego w ArticleSearchParams
      |> Map.put("media", "True")
  end

end
