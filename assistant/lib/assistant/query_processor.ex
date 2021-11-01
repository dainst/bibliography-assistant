defmodule Assistant.QueryProcessor do

  import Assistant.ZenonService

  def try_queries result, {author_simple, author_complex, title} do

    shortened_title = shorten title

    {_, results} = result = query_zenon_with_author_and_title author_complex, title
    if length(results) > 0 do
      result
    else
      {_, results} = result = query_zenon_with_author_and_title author_complex, shortened_title
      if length(results) > 0 do
        result
      else
        {_, results} = result = query_zenon_with_author_and_title author_simple, title
        if length(results) > 0 do
          result
        else
          {_, results} = result = query_zenon_with_author_and_title author_simple, shortened_title
          if length(results) > 0 do
            result
          else
            {_, results} = result= query_zenon_with_author_and_title author_complex, nil
            if length(results) > 0 do
              result
            else
              query_zenon_with_author_and_title author_simple, nil
            end
          end
        end
      end
    end
  end

  defp shorten str do
    str
    |> String.split(~r/[:.,]/)
    |> List.first
  end
end
