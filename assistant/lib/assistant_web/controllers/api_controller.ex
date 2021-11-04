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

  defp convert [x,y,z] do
    %{
      given: x,
      "primary-author-given-name": AnystyleHelper.extract_primary_author_given_name(y),
      "primary-author-family-name": AnystyleHelper.extract_primary_author_family_name(y),
      title: AnystyleHelper.extract_primary_title(y)
    }
  end
end
