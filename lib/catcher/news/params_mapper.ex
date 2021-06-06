defmodule Catcher.News.ParamsMapper do
  alias Catcher.News.ArticleSearchParams
  alias Catcher.News.ParamsHelper

  def generate_query_params(params) do
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
      |> Enum.filter(fn {_key, value} -> ParamsHelper.param_not_empty?(value) end)
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

  def map_params_for_request_structure(params) do

  end

end
