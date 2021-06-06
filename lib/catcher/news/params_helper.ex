defmodule Catcher.News.ParamsHelper do

  def struct_keys_as_string(struct) do
    struct
    |> Map.keys()
    |> List.delete(:__struct__)
    |> List.delete(:__meta__)
    |> Enum.map(fn key -> Atom.to_string(key) end)
  end

  def param_exist_and_not_empty?(name, params_list) do
    Enum.find(Map.keys(params_list), fn key -> key == name end) &&
      param_not_empty?(params_list[name])
  end

  def param_not_empty?(param) do
    param && String.length(String.trim(param)) != 0
  end

end
