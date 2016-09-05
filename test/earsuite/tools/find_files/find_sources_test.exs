defmodule Earsuite.Tools.FindFiles.FindSourcesTest do
  use ExUnit.Case
  
  import Earsuite.Tools, only: [find_sources: 1]

  @fixture_dir "test/fixtures/find_files"

  describe "find_source_files" do
    test "empty" do 
      assert [] == sources("#{@fixture_dir}/level1/empty")
    end
    test "sources at level1" do 
      expected = ~w(level1/elixir. level1/markdown.) |> normalized_result()
      assert expected == sources("#{@fixture_dir}/level1") |> Enum.sort()
    end
    test "all sources" do 
      expected =
        ~w(base. base1. both. level1/elixir. level1/markdown.) |> normalized_result()
      assert expected == sources(@fixture_dir) |> Enum.sort()
    end
  end

  defp normalized_result files do
    files
    |> Enum.sort()
    |> Enum.map(fn f -> [@fixture_dir, f] |> Enum.join("/") end)
  end

  defp sources(dir) do
    find_sources(dir)
    |> Enum.sort()
  end
end
