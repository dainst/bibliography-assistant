defmodule AssistantWeb.AnystyleResultComponent do
  use AssistantWeb, :live_component

  alias Assistant.Sort
  alias Assistant.Translator
  alias Assistant.Anystyle.Helper


  def sort item do
    Sort.sort_map item, Application.fetch_env!(:assistant, :orderable_keys)
  end

  def convert_key key, lang do
    Translator.translate String.to_atom("anystyle_field_#{key}"), lang
  end

  def convert([a|_]) when is_binary(a), do: a

  def convert(param) when is_binary(param), do: param

  def convert(_param), do: ""
end
