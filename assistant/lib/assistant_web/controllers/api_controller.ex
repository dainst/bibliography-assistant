defmodule AssistantWeb.ApiController do
  use AssistantWeb, :controller

  alias Plug.Conn
  alias Assistant.Dispatch

  def evaluate conn, %{ "parser" => parser, "references" => references } do
    results = Dispatch.query parser, references
    results = Enum.map(results, fn [x,y,z] -> %{ given: x, parser_output: y } end)
    json conn, %{ results: results }
  end
end
