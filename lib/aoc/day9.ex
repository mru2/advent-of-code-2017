defmodule Aoc.Day9 do
  def parse_input([line]) do
    String.split(line, "")
    |> parse
  end

  def solve1(tokens) do
    tokens
    |> Enum.flat_map_reduce(1, fn
         :open_group, i -> {[i], i + 1}
         :close_group, i -> {[], i - 1}
         _, i -> {[], i}
       end)
    |> elem(0)
    |> Enum.sum()
  end

  def solve2(tokens) do
    tokens
    |> Enum.count(fn token -> token == :garbage end)
  end

  defp parse(["{" | rest]), do: [:open_group | parse(rest)]
  defp parse(["}" | rest]), do: [:close_group | parse(rest)]
  defp parse(["!" | [_ | rest]]), do: parse(rest)
  defp parse(["<" | rest]), do: [:open_garbage | garbage(rest)]
  defp parse([_ | rest]), do: parse(rest)
  defp parse([]), do: []

  defp garbage([">" | rest]), do: [:close_garbage | parse(rest)]
  defp garbage(["!" | [_ | rest]]), do: garbage(rest)
  defp garbage([_ | rest]), do: [:garbage | garbage(rest)]
  defp garbage([]), do: []
end
