defmodule Earsuite.Tools.FindFiles.FindSpecsTest do
  use ExUnit.Case
  
  import Earsuite.Tools, only: [find_specs: 1]

  @fixture_dir "test/fixtures/matchings"

  describe "triples returned by find_specs" do
    test "all" do 
      expected = [
        {nil, "level1/md_and_html.md", "level1/md_and_html.html"},
        {nil, "level1/only_md.md", nil},
        {"base.ex", nil, "base.html"}, 
        {"base1.exs", nil, nil},
        {"level1/level2/all_three.ex", "level1/level2/all_three.md", "level1/level2/all_three.html"}
      ] |> normalize_result()
      assert expected == specs(@fixture_dir)
    end

    test "exs only" do 
      
    end
  end

  defp normalize_result tuples do
    tuples
    |> Enum.sort()
    |> Enum.map( &normalize_tuple/1 )
  end

  defp normalize_tuple t do
    t
    |> Tuple.to_list()
    |> Enum.map(&normalize_value/1)
    |> tuple_from_list()
  end

  defp normalize_value(nil), do: nil
  defp normalize_value(str), do: "#{@fixture_dir}/#{str}"

  defp specs(dir), do: dir |> find_specs() |> Enum.sort()

  # Why is Tuple not a Collectable and Enumerable ?
  defp tuple_from_list( list), do:
    Enum.reduce(list, {}, fn x, acc -> Tuple.append(acc, x) end)
end
