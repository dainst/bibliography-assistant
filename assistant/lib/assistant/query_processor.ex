defmodule Assistant.QueryProcessor do

  import Assistant.ZenonService

  def try_queries {author_simple, author_complex, title} do

    shortened_title = shorten title

    with {_, {0, []}} <- query_zenon_with_author_and_title(author_complex, title),
         {_, {0, []}} <- query_zenon_with_author_and_title(author_complex, shortened_title),
         {_, {0, []}} <- query_zenon_with_author_and_title(author_simple, title),
         {_, {0, []}} <- query_zenon_with_author_and_title(author_simple, shortened_title),
         {_, {0, []}} <- query_zenon_with_author_and_title(author_complex, nil),
         {_, {0, []}} = result <- query_zenon_with_author_and_title(author_simple, nil)
    do
      result
    else
      result -> result
    end
  end

  defp shorten str do
    str
    |> String.split(~r/[:.,]/)
    |> List.first
  end
end
