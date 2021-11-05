defmodule AssistantWeb.ApiControllerTest do
  use AssistantWeb.ConnCase

  test "say_hello", %{conn: conn} do
    conn =
      conn
      |> put_req_header("content-type", "text/plain")
      |> post(Routes.api_path(conn, :say_hello), "hello")
    %{ "message" => "hello" } = Poison.decode!(conn.resp_body)
  end
end
