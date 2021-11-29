defmodule Assistant.Grobid.Helper do

  import String

  def convert_item item do
    item
    |> Map.merge(%{
      "given-name": extract_given_name(item),
      "family-name": extract_family_name(item)
    })
    |> Map.delete(:citekey)
    |> Map.delete(:author)
  end

  def extract item, key do
    if value = item[key] do
      value
    else
      ""
    end
  end

  # TODO remove duplication (with Anystyle.Helper)
  defp extract_given_name entry do
    case extract_author entry do
      {_family, given} -> given
      _ -> ""
    end
  end

  # TODO remove duplication (with Anystyle.Helper)
  defp extract_family_name entry do
    case extract_author entry do
      {family, _given} -> family
      _ -> ""
    end
  end

  # TODO remove duplication (with Anystyle.Helper)
  def extract_author_and_title result do

    author = extract_author result
    title = extract_title result

    {author, title}
  end

  defp extract_title item do
    unless is_nil(item[:title]) do
      item[:title]
      |> String.replace(~r["], "")
      |> String.split(":")
      |> List.first
    end # TODO else? ""
  end

  defp extract_author item do

    author =
      item[:author]
      |> split(~r/\sand\s/) # this is grobid's way of separating authors
      |> List.first

    num_commas = Kernel.length Regex.scan ~r/,/, author

    if num_commas == 1 do
      author = replace author, "\s", ""
      [family, given] = split author, ","
      {family, given}
    else
      author
      |> replace(~r/[-–,]/, " ")
      |> replace(~r/\s[A-Za-z]\s/, "")
      |> replace(~r/^[A-Za-z]\s/, "")
      |> replace(~r/\s[A-Za-z]$/, "")
      |> split("\s")
      |> List.first
    end
  end
end
