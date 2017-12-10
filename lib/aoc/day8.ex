defmodule Aoc.Day8 do
  def parse_input(rows) do
    rows
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(line) do
    [var1, cmd, val, "if", var2, cnd, dig] = String.split(line, " ")
    {{var1, cmd, Aoc.to_int(val)}, {var2, cnd, Aoc.to_int(dig)}}
  end

  def run(input) do
    Enum.reduce(input, {%{}, 0}, fn {cmd, cnd}, {data, max} ->
      new_data =
        case check_cnd(cnd, data) do
          false -> data
          true -> apply_cmd(cmd, data)
        end

      {new_data, max(data_max(new_data), max)}
    end)
  end

  def solve1(input) do
    {data, _max} = input |> run
    data_max(data)
  end

  def solve2(input), do: input |> run |> elem(1)

  def data_max(data) do
    data
    |> Enum.max_by(fn {k, v} -> v end)
    |> elem(1)
  end

  defp check_cnd({var, op, val}, data) do
    cur = Map.get(data, var, 0)

    case op do
      ">" -> cur > val
      ">=" -> cur >= val
      "<" -> cur < val
      "<=" -> cur <= val
      "==" -> cur == val
      "!=" -> cur != val
    end
  end

  def apply_cmd({var, op, val}, data) do
    cur = Map.get(data, var, 0)

    new =
      case op do
        "inc" -> cur + val
        "dec" -> cur - val
      end

    Map.put(data, var, new)
  end
end
