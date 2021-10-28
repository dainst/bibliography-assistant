defmodule AssistantWeb.DownloadController do
  use AssistantWeb, :controller

  def download conn, %{ "id" => id } do
    conn
    |> send_download({:file, "priv/#{id}.csv"})
  end
end
