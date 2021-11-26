defmodule Assistant.Dispatch do

  alias Assistant.GrobidQueryProcessor
  alias Assistant.CermineQueryProcessor
  alias Assistant.AnystyleQueryProcessor

  @doc """
  Returns {:error, reason} if an error occured
  """
  def query "anystyle", raw_references do
    do_query raw_references, &AnystyleQueryProcessor.process_query/1
  end
  def query "grobid", raw_references do
    do_query raw_references, &GrobidQueryProcessor.process_query/1
  end

  defp do_query raw_references, process_query do
    result =
      raw_references
      |> add_split_references
      |> process_query.()

    case result do
      {:error, _} = error -> error
      result -> Enum.map(result, &(Tuple.to_list &1))
    end
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
