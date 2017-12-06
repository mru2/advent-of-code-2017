defmodule Aoc.Day0 do
  def parse_input(input), do: input

  def solve1(input) do
    "Line count is #{length(input)}"
  end

  def solve2(input) do
    "First item is #{hd(input)}"
  end
end
