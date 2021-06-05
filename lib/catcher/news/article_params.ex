defmodule Catcher.News.ArticleParams do

  # default params
  @x_rapidAPI_key ~s(a07310d6eemshb4b7333c5a87796p1a3c3cjsn64aaccca4d36)
  @page ~s(1)
  @page_size ~s(5)
  @from ~s(2020-01-01 00:00:00)

  # possible params_list range
  @lang ~w(af ar bg bn ca cn cs cy da de el en es et fa fi
    fr gu he hi hr hu id it ja kn ko lt lv mk ml mr ne nl no
    pa pl pt ro ru sk sl so sq sv sw ta te th tl tr tw uk ur vi
  )
  @sort_by ~w(relevancy date rank)
  @topic ~w(news sport tech world finance politics business economics entertainment beauty travel music food science)

  # params_list example
  @query ~s(Example: coronavirus and covid)
  @sources ~s(Example: webmd.com)
  # w kodzie jest data wykonania zapytania czyli NaiveDateTime.to_string(NaiveDateTime.local_now())
  @to ~s(Example date format: 2021-06-01 00:00:00)

  defstruct page: @page, page_size: @page_size, query: @query, lang: @lang, sort_by: @sort_by, from: @from, to: @to, topic: @topic, sources: @sources, x_rapidAPI_key: @x_rapidAPI_key

  def default_values do
    __struct__()
  end

  def unique_string_keys do
    string_keys() -- ["page", "page_size", "x_rapidAPI_key"]
  end

  def valid_string_keys do
    string_keys() -- ["x_rapidAPI_key"]
  end

  def string_keys do
   __struct__()
    |> Map.keys()
    |> List.delete(:__struct__)
    |> Enum.map(fn key -> Atom.to_string(key) end)
  end

  def query_param_exist_and_not_empty?(name, params_list) do
    Enum.find(Map.keys(params_list), fn key -> key == name end)
      && query_param_not_empty?(params_list[name])
  end

  def query_param_not_empty?(param) do
    String.length(String.trim param) != 0
  end
end
