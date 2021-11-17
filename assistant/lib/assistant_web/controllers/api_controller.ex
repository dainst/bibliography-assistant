defmodule AssistantWeb.ApiController do
  use AssistantWeb, :controller

  alias Assistant.AnystyleHelper
  alias Assistant.Dispatch

  def evaluate conn, _body do

    {:ok, references, _} = Plug.Conn.read_body(conn)

    results = Dispatch.query "anystyle", references
    results = Enum.map(results, &convert/1)
    json conn, %{ results: results }
  end

  defp convert [original, item, {{_ui_suffix, api_suffix}, {num_records, records}}] do
    converted = AnystyleHelper.convert_item item
    Map.merge %{ original: original,
                 autoselected_zenon_item_id: (if num_records == 1 do List.first(records)["id"] end),
                 search_suffix: api_suffix }, converted
  end

  # Just for setting up a controller test
  def say_hello conn, _body do
    {:ok, message, _} = Plug.Conn.read_body(conn)
    json conn, %{ message: message }
  end
end
