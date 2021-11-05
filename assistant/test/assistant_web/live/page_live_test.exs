defmodule AssistantWeb.PageLiveTest do
  use AssistantWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Bibliographische Referenzen"
    assert render(page_live) =~ "Bibliographische Referenzen"
  end
end
