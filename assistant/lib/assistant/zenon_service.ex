defmodule Assistant.ZenonService do

  def query_zenon_with_author_and_title nil, _ do
    {:error, :illegal_argument_author_must_not_be_nil}
  end

  def query_zenon_with_author_and_title _, nil do
    {:error, :illegal_argument_title_must_not_be_nil}
  end

  def query_zenon_with_author_and_title author, title do

    suffixes = if author == "" do
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
        {author, title} ->
          t = String.replace(title," ","+")
          {
            "author:#{author} and title:#{title}",
            "lookfor0[]=#{author}&type0[]=Author&lookfor0[]=#{t}&type0[]=AllFields"
          }
      end
    end

    IO.inspect elem(suffixes, 0)
    if suffixes != {"", ""} do
      query_with_suffix suffixes
    else
      {{"", ""}, 0, []}
    end
  end

  defp query_with_suffix {api_suffix, ui_suffix} do

    zenon_url = Application.fetch_env!(:assistant, :zenon_url)
    suffix = :http_uri.encode api_suffix

    suffixes = {api_suffix, :http_uri.encode(ui_suffix)
      |> String.replace("%3D", "=") |> String.replace("%26","&")}

    with {:ok, results} <- HTTPoison.get "#{zenon_url}/api/v1/search?limit=100&lookfor=#{suffix}", %{}, [] do
      results = Poison.decode! results.body

      if is_nil(results["records"]) do
        {suffixes, {0, []}}
      else
        {suffixes, {results["resultCount"], results["records"]}}
      end
    else
      {:error, error} ->
        IO.puts "Zenon Service not reachable"
        IO.inspect error
        {:error, :zenon_unreachable}
    end
  end
end
