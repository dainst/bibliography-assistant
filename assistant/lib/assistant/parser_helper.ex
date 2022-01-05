defmodule Assistant.ParserHelper do

  def get_second(nil), do: ""
  def get_second({_, second}), do: second || ""

  def get_first(nil), do: ""
  def get_first({first, _}), do: first || ""
end
