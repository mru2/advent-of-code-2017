defmodule Mix.Tasks.Solve do
  use Mix.Task

  @shortdoc "Solves a given day : `mix solve day1`"
  def run([file]) do
    with {:ok, lines} <- read_lines("inputs/#{file}.txt"),
         {:ok, module} <- find_module("Aoc.#{String.capitalize(file)}") do
      out1 = apply(module, :solve1, [lines])
      out2 = apply(module, :solve2, [lines])
      IO.puts("Solution 1 : #{out1}")
      IO.puts("Solution 2 : #{out2}")
    else
      {:error, :no_file} ->
        IO.puts("No input found at inputs/#{file}.txt")

      {:error, :undefined_module} ->
        IO.puts("No module named Aoc.#{String.capitalize(file)} found")

      error ->
        IO.puts("An error happened : #{inspect(error)}")
    end
  end

  def run(_), do: IO.puts("No day specified. Example usage : `mix solve day1`")

  defp read_lines(file) do
    case File.exists?(file) do
      false ->
        {:error, :no_file}

      true ->
        lines = File.stream!(file) |> Enum.to_list()
        {:ok, lines}
    end
  end

  defp find_module(name) do
    case Code.ensure_loaded(:"Elixir.#{name}") do
      {:error, :nofile} -> {:error, :undefined_module}
      {:module, module} -> {:ok, module}
    end
  end
end
