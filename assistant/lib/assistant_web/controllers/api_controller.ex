defmodule AssistantWeb.ApiController do
  use AssistantWeb, :controller

  alias Plug.Conn
  alias Assistant.Dispatch

  def evaluate conn, _params do
    {:ok, body, conn} = Conn.read_body conn
    %{ "parser" => parser, "references" => references } = Poison.decode! body
    results = Dispatch.query parser, references
    json conn, %{ results: results }
  end
end
