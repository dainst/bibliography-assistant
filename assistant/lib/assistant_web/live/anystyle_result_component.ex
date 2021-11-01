defmodule AssistantWeb.AnystyleResultComponent do
  use AssistantWeb, :live_component

  alias Assistant.AnystyleHelper
  alias Assistant.QueryProcessorHelper
  alias AssistantWeb.AnystyleResultComponent

  def convert_key key do
    case key do
      "author" -> "Primary Author"
      something -> something
    end
    |> :string.titlecase
  end

  def convert [%{} = a|_] = param do
    primary_author = AnystyleHelper.extract_primary_author %{ "author" => param }

    if primary_author do
      QueryProcessorHelper.complex_name primary_author
    else
      ""
    end
  end

  def convert([a|_] = param) when is_binary(a) do
    a
  end

  def convert(param) when is_binary(param) do
    param
  end

  def convert _param do
    ""
  end
end
