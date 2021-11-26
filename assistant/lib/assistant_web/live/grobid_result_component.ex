defmodule AssistantWeb.GrobidResultComponent do
  use AssistantWeb, :live_component

  alias Assistant.Translator

  def convert_item item do
    Map.delete item, :citekey
  end

  def convert_key key, lang do
    result = Translator.translate String.to_atom("grobid_field_#{key}"), lang
    if result do
      result
    else
      key
    end
  end

  def convert([a|_]) when is_binary(a), do: a

  def convert(param) when is_binary(param), do: param

  def convert(_param), do: ""
end
