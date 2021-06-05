defmodule Catcher.News.ArticleParams do

  @query ~s(coronavirus)
  @x_RapidAPI_key ~s(a07310d6eemshb4b7333c5a87796p1a3c3cjsn64aaccca4d36)
  @lang ~w(af ar bg bn ca cn cs cy da de el en es et fa fi fr gu he hi hr hu id it ja kn ko lt lv mk ml mr ne nl no pa pl pt ro ru sk sl so sq sv sw ta te th tl tr tw uk ur vi)
  @sort_by ~w(relevancy date rank)
  @from ~N[2020-01-01 00:00:00]
  @to NaiveDateTime.local_now()
  @topic ~w(news sport tech world finance politics business economics entertainment beauty travel music food science)
  @sources "webmd.com"

  defstruct page: "1", page_size: "5", query: @query, lang: @lang, sort_by: @sort_by, from: @from, to: @to, topic: @topic, sources: @sources, X_RapidAPI_Key: @x_RapidAPI_key

  def default_values do
    __struct__()
  end

  def filtred_string_keys do
    string_keys() -- ["page", "page_size", "X_RapidAPI_Key"]
  end

  def string_keys do
   __struct__()
    |> Map.keys()
    |> List.delete(:__struct__)
    |> Enum.map(fn key -> Atom.to_string(key) end)
  end
end
