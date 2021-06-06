defmodule Catcher.News.ParamsMapper do
  alias Catcher.News.ArticleSearchParams
  alias Catcher.News.ParamsHelper

  def generate_query_params(params) do
    params
    |> Map.update("from", ArticleSearchParams.default_values().from, fn old_value -> old_value end)
    |> Map.update("to", NaiveDateTime.to_string(NaiveDateTime.new!(Date.utc_today(), ~T[00:00:00])), fn old_value ->
      old_value
    end)
    |> Map.update("lang", "", fn old_value ->
      if old_value not in ArticleSearchParams.default_values().lang, do: "", else: old_value end)
    |> Map.update("sort_by", "", fn old_value ->
      if old_value not in ArticleSearchParams.default_values().sort_by, do: "", else: old_value end)
    |> Map.update("topic", "", fn old_value ->
      if old_value not in ArticleSearchParams.default_values().topic, do: "", else: old_value end)
    # filtrowanie pustych paramsów
    |> Enum.filter(fn {_key, value} -> ParamsHelper.param_not_empty?(value) end)
    # filtrowanie żeby nie było jakiś dziwnych paramsów (tylko te zdefiniowane)
    |> Enum.filter(fn {key, _value} -> key in ArticleSearchParams.valid_string_keys() end)
    # zamiana query na q
    |> Map.new(fn {key, value} ->
      if key == "query", do: {"q", value}, else: {key, value}
    end)
    # Należy dodać ponieważ to zawsze będzie występować i nie ma tego w ArticleSearchParams
    |> Map.put("media", "True")
  end

  def map_params_for_request_structure(params) do
    params = params
    |> Map.delete("media")
    |> Enum.map(fn {key, value} ->
      if key == "q", do: {String.to_atom("query"), value}, else: {String.to_atom(key), value} end)
    |> Enum.map(fn {key, value} ->
      if key in [:to, :from], do: {key, NaiveDateTime.from_iso8601!(value)}, else: {key, value} end)
    |> Enum.map(fn {key, value} ->
      if key in [:page, :page_size], do: {key, String.to_integer(value)}, else: {key, value} end)
  end
end
