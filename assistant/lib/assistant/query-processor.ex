defmodule Assistant.QueryProcessor do

  import Assistant.ZenonService

  def try_queries result, {author_simple, author_complex, title} do
    {_, results} = result = query_zenon_with_author_and_title author_complex, title
    unless Kernel.length(results) == 0 do
      result
    else
      {_, results} = result = query_zenon_with_author_and_title author_simple, title
      unless Kernel.length(results) == 0 do
        result
      else
        {_, results} = result= query_zenon_with_author_and_title author_complex, nil
        unless Kernel.length(results) == 0 do
          result
        else
          query_zenon_with_author_and_title author_simple, nil
        end
      end
    end
  end
end
