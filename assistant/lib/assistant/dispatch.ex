defmodule Assistant.Dispatch do

  alias Assistant.GrobidQueryProcessor
  alias Assistant.CermineQueryProcessor
  alias Assistant.AnystyleQueryProcessor

  def query "anystyle", raw_references do
    do_query raw_references, &AnystyleQueryProcessor.process_query/1
  end

  def query "grobid", raw_references do
    do_query raw_references, &GrobidQueryProcessor.process_query/1
  end

  def query "cermine", raw_references do
    do_query raw_references, &CermineQueryProcessor.process_query/1
  end

  defp do_query raw_references, process_query do
    raw_references
    |> add_split_references
    |> process_query.()
    |> Enum.map(fn {x,y,z} -> [x,y,z] end)
  end

  defp add_split_references raw_references do
    split_references =
      raw_references
      |> String.split(["\n", "\r", "\r\n"])
      |> Enum.reject(&(&1 == ""))
    {
      raw_references,
      split_references
    }
  end
end
