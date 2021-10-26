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
          {"", []}
      end
    else
      {"", []}
    end
  end

  def query_zenon_with_author_and_title author, title do
    suffix = if author == "" or author == nil do
      case title do
        nil -> nil
        title -> "title:#{title}"
      end
    else
      case {author, title} do
        {author, ""} -> "author:#{author}"
        {author, nil} -> "author:#{author}"
        {author, title} -> "author:#{author} and title:#{title}"
        _ -> nil
      end
    end

    IO.inspect suffix
    if suffix do
      query_with_suffix suffix
    else
      {"", []}
    end
  end

  defp query_with_suffix suffix do

    zenon_url = Application.fetch_env!(:assistant, :zenon_url)
    suffix = :http_uri.encode suffix

    with {:ok, results} <- HTTPoison.get "#{zenon_url}/api/v1/search?limit=100&lookfor=#{suffix}", %{}, [] do
      results = Poison.decode! results.body

      if is_nil(results["records"]) do
        {suffix, []}
      else
        {suffix, results["records"]}
      end
    else
      {:error, error} ->
        IO.puts "Zenon Service not reachable"
        IO.inspect error
        {"", []}
    end
  end
end
