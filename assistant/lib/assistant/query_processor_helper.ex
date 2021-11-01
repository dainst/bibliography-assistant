defmodule Assistant.QueryProcessorHelper do

  def convert author, title do
    {simple_name(author), complex_name(author), title}
  end

  def complex_name author do
    case author do
      {family, given} -> "#{given}.#{family}"
      _ -> author
    end
  end

  defp simple_name author do
    case author do
      {family, given} -> family
      _ -> author
    end
  end
end
