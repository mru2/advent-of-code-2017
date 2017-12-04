defmodule Aoc.Day3.Spiral do
  defstruct values: %{{0, 0} => 1}, direction: :right, current: {0, 0}

  alias __MODULE__

  def new do
    %Spiral{}
  end

  def next(spiral = %Spiral{values: values, current: current}) do
    value = values[current]
    {[values[current]], iterate(spiral)}
  end

  defp iterate(spiral = %Spiral{values: values, direction: direction, current: current}) do
    spiral
    |> update_direction
    |> update_current
    |> update_values
  end

  # Update current position
  defp update_current(spiral = %Spiral{direction: direction, current: current}),
    do: %Spiral{spiral | current: next_current(direction, current)}

  defp next_current(:right, {x, y}), do: {x + 1, y}
  defp next_current(:left, {x, y}), do: {x - 1, y}
  defp next_current(:top, {x, y}), do: {x, y + 1}
  defp next_current(:bottom, {x, y}), do: {x, y - 1}

  # Update direction
  defp update_direction(spiral = %Spiral{direction: direction, current: current}),
    do: %Spiral{spiral | direction: next_direction(direction, current)}

  # Top left corner
  defp next_direction(:top, {x, y}) when x > 0 and y > 0 and x == y, do: :left
  # Top right corner
  defp next_direction(:left, {x, y}) when x < 0 and y > 0 and x == -y, do: :bottom
  # Bottom left corner
  defp next_direction(:bottom, {x, y}) when x < 0 and y < 0 and x == y, do: :right
  # Bottom right corner (1 square to the right)
  defp next_direction(:right, {x, y}) when x > 0 and y <= 0 and x == -y + 1, do: :top
  # Keep current direction otherwise
  defp next_direction(dir, _), do: dir

  # Update values : sum neighbour values
  defp update_values(spiral = %Spiral{values: values, current: current = {x, y}}) do
    new_value = %Spiral{spiral | values: Map.put(values, current, compute_value(values, current))}
  end

  defp compute_value(values, {x, y}) do
    [
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1}
    ]
    |> Enum.map(fn coords -> Map.get(values, coords, 0) end)
    |> Enum.sum()
  end
end
