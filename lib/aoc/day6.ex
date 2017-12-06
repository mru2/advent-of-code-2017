defmodule Aoc.Day6 do
  def parse_input([input]) do
    input
    |> String.split(~r/\s+/, trim: true)
    |> Enum.map(&Aoc.to_int/1)
  end

  def solve1(values) do
    {_list, count, _cache} = do_solve(values, 0, MapSet.new())
    count
  end

  def solve2(values) do
    {list, count, cache} = do_solve(values, 0, MapSet.new())
    {_list, count, _cache} = do_solve(iterate(list), 1, MapSet.new([list]))
    count
  end

  defp do_solve(list, count, cache) do
    case MapSet.member?(cache, list) do
      true -> {list, count, cache}
      false -> do_solve(iterate(list), count + 1, MapSet.put(cache, list))
    end
  end

  defp iterate(list) do
    {max, index, list} = pop_max(list)
    len = length(list)

    (index + 1)..(index + max)
    |> Enum.reduce(list, fn i, list ->
         List.update_at(list, rem(i, len), &(&1 + 1))
       end)
  end

  defp pop_max(list) do
    max = Enum.max(list)
    index = Enum.find_index(list, fn val -> val == max end)
    {max, index, List.replace_at(list, index, 0)}
  end
end
