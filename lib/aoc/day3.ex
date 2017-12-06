defmodule Aoc.Day3 do
  alias Aoc.Day3.Spiral

  def parse_input([input]) do
    Aoc.to_int(input)
  end

  def solve1(value) do
    value
    |> distance_to_origin
  end

  def solve2(value) do
    Stream.resource(&Spiral.new/0, &Spiral.next/1, & &1)
    |> Stream.drop_while(&(&1 <= value))
    |> Enum.take(1)
    |> hd
  end

  # 1 - find out on which circle the number is (odd squares start every one)
  # 2 - find out its position from the row / column start
  # 3 - deduct its distance from the row / column center
  # 4 - add it to the index for its distance to the origin
  defp distance_to_origin(number) do
    index = ((:math.sqrt(number) - 1) / 2) |> :math.ceil() |> round
    min = (index * 2 - 1) |> :math.pow(2) |> round
    delta = number - min
    row_index = rem(delta - 1, 2 * index)
    distance_to_row_center = rem(abs(row_index - index + 1), index + 1)
    index + distance_to_row_center
  end
end
