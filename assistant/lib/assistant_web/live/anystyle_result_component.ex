defmodule AssistantWeb.AnystyleResultComponent do
  use AssistantWeb, :live_component

  alias Assistant.Translator
  alias Assistant.AnystyleHelper
  alias AssistantWeb.AnystyleResultComponent

  def convert_item item do
    AnystyleHelper.convert_item item
  end

  def convert_key key, lang do
    Translator.translate String.to_atom("anystyle_field_#{key}"), lang
  end

  def convert([a|_]) when is_binary(a), do: a

  def convert(param) when is_binary(param), do: param

  def convert(_param), do: ""
end
