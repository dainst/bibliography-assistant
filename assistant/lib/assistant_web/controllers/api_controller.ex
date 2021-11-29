defmodule AssistantWeb.ApiController do
  use AssistantWeb, :controller

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
    fn [original,
        {_parser_result, converted_parser_result},
        {{_ui_suffix, api_suffix}, {num_records, records}}] ->

      Map.merge %{
        original: original,
        autoselected_zenon_item_id: (if num_records == 1 do List.first(records)["id"] end),
        search_suffix: api_suffix
      }, converted_parser_result
    end
  end

  # Just for setting up a controller test
  def say_hello conn, _body do
    {:ok, message, _} = Plug.Conn.read_body(conn)
    json conn, %{ message: message }
  end
end
