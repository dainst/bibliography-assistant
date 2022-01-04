defmodule Assistant.Sort do

  @doc """
  Sorts key-value-pairs of a map following a specified order.

  ## Examples
    iex> Sort.sort_map %{a: 3, b: 4}, {}
    [a: 3, b: 4]
    iex> Sort.sort_map %{a: 3, b: 4}, {:b}
    [b: 4, a: 3]
    iex> Sort.sort_map %{a: 3, b: 4}, {:b, :a, :c}
    [b: 4, a: 3]
  """
  def sort_map map = %{}, orderable_keys do

    nil_tuple = nil_tuple_of_same_length_as(orderable_keys)
    orderable_keys = Tuple.to_list(orderable_keys)

    {sorted_els, els}
      = Enum.reduce map, {nil_tuple, []}, fn el = {k,_v}, {sorted_els, els} ->

        if index = Enum.find_index orderable_keys, &(&1 == k) do
          {
            put_elem(sorted_els, index, el),
            els
          }
        else
          {
            sorted_els,
            els ++ [el]
          }
        end
      end
    sorted_els = Enum.filter Tuple.to_list(sorted_els), &(&1 != nil)
    sorted_els ++ els
  end

  defp nil_tuple_of_same_length_as tuple do
    List.to_tuple(List.duplicate(nil, length Tuple.to_list(tuple)))
  end
end
