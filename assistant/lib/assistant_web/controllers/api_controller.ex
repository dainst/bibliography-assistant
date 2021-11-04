defmodule AssistantWeb.ApiController do
  use AssistantWeb, :controller

  alias Plug.Conn
  alias Assistant.Dispatch

  def evaluate conn, body do

    {:ok, references, _} = Plug.Conn.read_body(conn)

    results = Dispatch.query "anystyle", references
    results = Enum.map(results, fn [x,y,z] -> %{ given: x, parser_output: y } end)
    json conn, %{ results: results }
  end
end
