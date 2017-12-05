defmodule Aoc.Day5 do
  defmodule Array do
    defstruct index: 0, values: nil, update: nil

    alias __MODULE__

    def new(list, update) do
      %Array{values: :array.from_list(list), update: update}
    end

    def walk(array = %Array{index: index}) when index < 0, do: {:halt, array}

    def walk(array = %Array{index: index, values: values, update: update}) do
      case :array.get(index, values) do
        :undefined ->
          {:halt, array}

        val ->
          {[val], %Array{
            array
            | index: index + val,
              values: :array.set(index, update.(val), values)
          }}
      end
    end
  end

  def solve1(input) do
    input
    |> Enum.map(&Aoc.to_int/1)
    |> count_steps(&update1/1)
  end

  def solve2(input) do
    input
    |> Enum.map(&Aoc.to_int/1)
    |> count_steps(&update2/1)
  end

  def update1(i), do: i + 1
  def update2(i) when i >= 3, do: i - 1
  def update2(i), do: i + 1

  defp count_steps(values, update) do
    Stream.resource(fn -> Array.new(values, update) end, &Array.walk/1, & &1)
    |> Enum.reduce(0, fn _val, count -> count + 1 end)
  end
end
