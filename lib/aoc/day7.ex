defmodule Aoc.Day7 do
  @regex ~r/^(?<id>\w+) \((?<weight>\d+)\)( -> (?<children>.+))?$/

  def parse_input(rows) do
    rows
    |> Enum.reduce(%{}, fn line, acc ->
         {{id, weight}, children} = parse_line(line)
         acc |> add_node(id, weight) |> add_children(id, children)
       end)

    # |> to_graph
  end

  defp parse_line(line) do
    case Regex.named_captures(@regex, line) do
      %{"id" => id, "weight" => weight, "children" => ""} ->
        {{id, Aoc.to_int(weight)}, []}

      %{"id" => id, "weight" => weight, "children" => children} ->
        {{id, Aoc.to_int(weight)}, String.split(children, ", ")}
    end
  end

  # Local node cache
  defp add_node(nodes, id, weight) do
    Map.update(nodes, id, {weight, nil, []}, fn {_, parent, children} ->
      {weight, parent, children}
    end)
  end

  defp add_children(nodes, parent_id, children) do
    Enum.reduce(children, nodes, fn child, acc -> add_child(acc, parent_id, child) end)
  end

  defp add_child(nodes, parent_id, child_id) do
    nodes
    |> Map.update(child_id, {nil, parent_id, []}, fn {weight, _, children} ->
         {weight, parent_id, children}
       end)
    |> Map.update(parent_id, {nil, nil, [child_id]}, fn {weight, parent, children} ->
         {weight, parent, [child_id | children]}
       end)
  end

  defp root(nodes) do
    {root_id, _} =
      Enum.find(nodes, fn {_id, {_weight, parent_id, _children}} -> parent_id == nil end)

    root_id
  end

  def solve1(nodes) do
    root(nodes)
  end

  def solve2(nodes) do
    find_mismatch(nodes, root(nodes), nil)
  end

  defp find_mismatch(nodes, node_id, expected_weight) do
    {weight, _parent, children} = Map.get(nodes, node_id)

    case outlier(children, fn child_id -> total_weight(nodes, child_id) end) do
      nil -> weight + expected_weight - total_weight(nodes, node_id)
      {child_id, expected_weight} -> find_mismatch(nodes, child_id, expected_weight)
    end
  end

  # Returns a {weight, nodes} tuple
  defp total_weight(nodes, node_id) do
    {weight, _parent, children} = Map.get(nodes, node_id)

    children_weight =
      children
      |> Enum.map(fn child_id -> total_weight(nodes, child_id) end)
      |> Enum.sum()

    weight + children_weight
  end

  # Return { id, expected_value } tuple
  defp outlier(coll, fun) do
    groups =
      coll
      |> Enum.group_by(fun)
      |> Enum.sort_by(fn {_val, ids} -> length(ids) end)

    case groups do
      [_] -> nil
      [{_out, [id]}, {expected, _others}] -> {id, expected}
    end
  end
end
