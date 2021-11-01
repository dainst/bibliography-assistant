defmodule Assistant.QueryProcessorHelper do

  def convert author, title do
    {simple_name(author), complex_name(author), title}
  end

  defp complex_name author do
    case author do
      {family, given} -> "#{remove_dots(given)}.#{family}"
      _ -> author
    end
  end

  defp simple_name author do
    case author do
      {family, given} -> family
      _ -> author
    end
  end

  defp remove_dots str do
    String.replace(str, ".", "")
  end
end
