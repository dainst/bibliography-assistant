defmodule Assistant.Grobid.Helper do

  import String

  def convert_item item do
    item
    |> Map.merge(%{
      "given-name": (elem (extract_author item), 1) || "",
      "family-name": (elem (extract_author item), 0) || ""
    })
    |> Map.delete(:citekey)
    |> Map.delete(:author)
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
