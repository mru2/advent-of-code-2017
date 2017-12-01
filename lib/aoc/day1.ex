defmodule Aoc.Day1 do
  def solve1([input]) do
    input
    |> to_int_list
    |> to_neighbour_pairs
    |> sum_matches
  end

  def solve2([input]) do
    input
    |> to_int_list
    |> to_opposite_pairs
    |> sum_matches
  end

  defp to_int_list(string) do
    string
    |> String.split("")
    |> Enum.flat_map(fn char ->
         case Integer.parse(char) do
           :error -> []
           {n, _} -> [n]
         end
       end)
  end

  defp to_neighbour_pairs(list = [h | t]) do
    translated = t ++ [h]
    Enum.zip(list, translated)
  end

  defp to_opposite_pairs(list) do
    half_len = (length(list) / 2) |> round
    [a, b] = Enum.chunk_every(list, half_len)
    rotated = b ++ a
    Enum.zip(list, rotated)
  end

  defp sum_matches(list) do
    list
    |> Enum.map(fn
         {a, a} -> a
         _ -> 0
       end)
    |> Enum.sum()
  end
end
