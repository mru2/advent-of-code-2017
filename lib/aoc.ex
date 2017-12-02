defmodule Aoc do
  # Helpers
  def to_int(char) do
    case Integer.parse(char) do
      :error -> nil
      {n, _} -> n
    end
  end
end
