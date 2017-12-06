defmodule Aoc.Day4 do
  def parse_input(input) do
    input
    |> Enum.map(&to_word_list/1)
  end

  def solve1(word_lists) do
    word_lists
    |> Enum.filter(&all_uniques?/1)
    |> length
  end

  def solve2(word_lists) do
    word_lists
    |> sort_chars
    |> Enum.filter(&all_uniques?/1)
    |> length
  end

  defp to_word_list(line), do: String.split(line, ~r{\s+}, trim: true)

  defp sort_chars(words) when is_list(words), do: Enum.map(words, &sort_chars/1)

  defp sort_chars(word) when is_binary(word), do: word |> to_charlist |> Enum.sort() |> to_string

  defp all_uniques?(words) do
    uniques_count(words) == length(words)
  end

  defp uniques_count(words) do
    words
    |> MapSet.new()
    |> MapSet.size()
  end
end
