defmodule AssistantWeb.ApiController do
  use AssistantWeb, :controller

  alias Plug.Conn
  alias Assistant.AnystyleHelper
  alias Assistant.Dispatch

  def evaluate conn, body do

    {:ok, references, _} = Plug.Conn.read_body(conn)

    results = Dispatch.query "anystyle", references
    results = Enum.map(results, &convert/1)
    json conn, %{ results: results }
  end

  defp convert [original, item, _] do
    converted = AnystyleHelper.convert_item item
    Map.merge %{ original: original }, converted
  end
end
