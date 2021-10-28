defmodule Assistant.ZenonService do

  def query_zenon(author) when is_nil(author) do
    {"", []}
  end

  def query_zenon author do
    if String.match?(author, ~r/^[A-Za-z]*$/) do

      zenon_url = Application.fetch_env!(:assistant, :zenon_url)

      with {:ok, results} <- HTTPoison.get "#{zenon_url}/api/v1/search?lookfor=author:#{author}", %{}, [] do
        results = Poison.decode! results.body
        {author, results["records"]}
      else
        {:error, error} ->
          IO.puts "Zenon Service not reachable"
          IO.inspect error
          {{"", ""}, []}
      end
    else
      {{"", ""}, []}
    end
  end

  def query_zenon_with_author_and_title author, title do
    suffixes = if author == "" or author == nil do
      case title do
        nil -> {"", ""}
        title -> {
          "title:#{title}",
          "lookfor0[]=#{title}&type0[]=AllFields"
        }
      end
    else
      case {author, title} do
        {author, ""} -> {
          "author:#{author}",
          "lookfor0[]=#{author}&type0[]=Author"
        }
        {author, nil} -> {
          "author:#{author}",
          "lookfor0[]=#{author}&type0[]=Author"
        }
        {author, title} ->
          t = String.replace(title," ","+")
          {
            "author:#{author} and title:#{title}",
            "lookfor0[]=#{author}&type0[]=Author&lookfor0[]=#{t}&type0[]=AllFields"
          }
        _ -> {"", ""}
      end
    end

    if suffixes != {"", ""} do
      query_with_suffix suffixes
    else
      {{"", ""}, []}
    end
  end

  defp query_with_suffix {api_suffix, ui_suffix} = suffixes do

    zenon_url = Application.fetch_env!(:assistant, :zenon_url)
    suffix = :http_uri.encode api_suffix

    suffixes = {api_suffix, :http_uri.encode(ui_suffix) |> String.replace("%3D", "=") |> String.replace("%26","&")}

    with {:ok, results} <- HTTPoison.get "#{zenon_url}/api/v1/search?limit=100&lookfor=#{suffix}", %{}, [] do
      results = Poison.decode! results.body

      if is_nil(results["records"]) do
        {suffixes, []}
      else
        {suffixes, results["records"]}
      end
    else
      {:error, error} ->
        IO.puts "Zenon Service not reachable"
        IO.inspect error
        {{"", ""}, []}
    end
  end
end
