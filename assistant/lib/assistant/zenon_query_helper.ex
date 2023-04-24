defmodule Assistant.ZenonQueryHelper do

  def prepare_queries_for_parser_result {_parser_result, converted_parser_result} do
    converted_parser_result
    |> extract_values_from_parser_result
    |> convert
    |> prepare_queries
  end

  defp prepare_queries {author_simple, author_complex, title, date} do
    shortened_title = shorten title

    # check output
    IO.inspect "------------------------"
    IO.puts shortened_title
    IO.puts title
    IO.puts author_simple
    IO.puts author_complex
    IO.puts date

    [
      extract_query_suffixes(author_simple, title, date), # "author:Leitmeir and title:Brüche im Kaiserbildnis von Caracalla bis Severus Alexander and date:2011"
      extract_query_suffixes(author_simple, shortened_title, date), # "author:Leitmeir and title:Brüche im Kaiserbildnis von Caracalla bis Severus Alexander and date:2011"
      extract_query_suffixes(author_complex, title, date), # "author:F.Leitmeir and title:Brüche im Kaiserbildnis von Caracalla bis Severus Alexander and date:2011"
      extract_query_suffixes(author_complex, shortened_title, date), # "author:F.Leitmeir and title:Brüche im Kaiserbildnis von Caracalla bis Severus Alexander and date:2011"
      # extract_query_suffixes("", title, date), # "title:Die Repräsentation der Soldatenkaiser: Studien zur kaiserlichen Selbstdarstellung im 3 and year:2018:"
      # extract_query_suffixes("", shortened_title, date), # "author:Leitmeir and title:Between Tradition and Innovation – the Visual Representation of Severan Emperors and date:"
    ]
  end

  # fn returns ui_suffix and api_suffix
  defp extract_query_suffixes author, title, date do
      case {author, title, date} do
        {author, title, date} ->
          t = String.replace(title," ","+")
          {
            "author:#{author} and year:#{date} and title:#{title}",   # api-suffix
            "lookfor0[]=#{author}&type0[]=Author&lookfor0[]=#{date}&type0[]=year&lookfor0[]=#{t}&type0[]=AllFields", # ui-suffix
          }
      end
  end

  defp shorten nil do
    ""
  end

  defp shorten str do
    str
    |> String.split(~r/[:.,\(]/)
    |> List.first
  end

  defp convert {author, title, date} do
    {simple_name(author) || "", complex_name(author) || "", title || "", date_YYYY(date) || ""}
  end

  defp extract_values_from_parser_result item do
    {{item[:"family-name"], item[:"given-name"]}, item[:title], item[:date]}
  end

  defp complex_name author do
    case author do
      {"", ""} -> ""
      {family, ""} -> family
      {family, given} -> "#{remove_dots(given)}.#{family}"
      _ -> ""
    end
  end

  defp simple_name author do
    case author do
      {"", _} -> ""
      {family, _given} -> family
      _ -> ""
    end
  end

  defp remove_dots str do
    String.replace(str, ".", "")
  end

  defp date_YYYY str do
    String.slice(str, 0..3)
  end
end
