defmodule AssistantWeb.AnystyleResultComponent do
  use AssistantWeb, :live_component

  alias Assistant.Translator
  alias Assistant.AnystyleHelper
  alias Assistant.QueryProcessorHelper
  alias AssistantWeb.AnystyleResultComponent

  def convert_key key, lang do
    Translator.translate String.to_atom("anystyle_field_#{key}"), lang
  end

  def convert [%{} = a|_] = param do
    primary_author = AnystyleHelper.extract_primary_author %{ "author" => param }

    if primary_author do
      {family, given} = primary_author
      "#{given}#{family}"
    else
      ""
    end
  end

  def convert([a|_] = param) when is_binary(a), do: a

  def convert(param) when is_binary(param), do: param

  def convert(_param), do: ""
end
