defmodule AssistantWeb.ApiController do
  use AssistantWeb, :controller

  alias Assistant.Anystyle.Helper, as: AnystyleHelper
  alias Assistant.Grobid.Helper, as: GrobidHelper
  alias Assistant.Dispatch

  def evaluate conn, params do

    parser = if Map.has_key? params, "parser" do
      params["parser"]
    else
      "anystyle"
    end

    {:ok, references, _} = Plug.Conn.read_body(conn)

    results = Dispatch.query parser, references
    results = Enum.map(results, convert(parser))
    json conn, %{ results: results }
  end

  defp convert parser do
    fn [original, item, {{_ui_suffix, api_suffix}, {num_records, records}}] ->
      converted = case parser do
        "anystyle" -> AnystyleHelper.convert_item item
        "grobid" -> GrobidHelper.convert_item item
      end
      Map.merge %{
        original: original,
        autoselected_zenon_item_id: (if num_records == 1 do List.first(records)["id"] end),
        search_suffix: api_suffix
      }, converted
    end
  end

  # Just for setting up a controller test
  def say_hello conn, _body do
    {:ok, message, _} = Plug.Conn.read_body(conn)
    json conn, %{ message: message }
  end
end
