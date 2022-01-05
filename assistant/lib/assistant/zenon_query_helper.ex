defmodule Assistant.ZenonQueryHelper do

  def prepare_queries_for_parser_result {_parser_result, converted_parser_result} do
    converted_parser_result
    |> extract_author_and_title
    |> convert
    |> prepare_queries
  end

  defp prepare_queries {author_simple, author_complex, title} do
    shortened_title = shorten title
    [
      extract_query_suffixes(author_complex, title),
      extract_query_suffixes(author_complex, shortened_title),
      extract_query_suffixes(author_simple, title),
      extract_query_suffixes(author_simple, shortened_title),
      extract_query_suffixes(author_complex, ""),
      extract_query_suffixes(author_simple, "")
    ]
  end

  defp extract_query_suffixes author, title do
    if author == "" do
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
  end

  defp shorten nil do
    ""
  end

  defp shorten str do
    str
    |> String.split(~r/[:.,]/)
    |> List.first
  end

  defp convert {author, title} do
    {simple_name(author) || "", complex_name(author) || "", title || ""}
  end

  defp extract_author_and_title item do
    {{item[:"family-name"], item[:"given-name"]}, item[:title]}
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
end
