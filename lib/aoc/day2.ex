defmodule Aoc.Day2 do
  def parse_input(rows) do
    rows
    |> Enum.map(fn row ->
         row |> String.split(~r/\s+/, trim: true) |> Enum.map(&Aoc.to_int/1)
       end)
  end

  def solve1(matrix) do
    matrix
    |> Enum.map(&checksum_minmax/1)
    |> Enum.sum()
  end

  def solve2(matrix) do
    matrix
    |> Enum.map(&checksum_divide/1)
    |> Enum.sum()
  end

  defp checksum_minmax(row) do
    Enum.max(row) - Enum.min(row)
  end

  defp checksum_divide(row) do
    row
    |> all_pairs
    |> Enum.map(fn {a, b} ->
         case rem(a, b) do
           0 -> div(a, b)
           _ -> 0
         end
       end)
    |> Enum.max()
  end

  defp all_pairs(list) do
    for elem <- list,
        rest <- list -- [elem],
        do: {elem, rest}
  end
end
