defmodule Earsuite.Tools.FindFiles.FindSourceFilesTest do
  use ExUnit.Case
  
  import Earsuite.Tools, only: [find_source_files: 1]

  @fixture_dir "test/fixtures/find_files"

  describe "find_source_files" do
    test "empty" do 
      assert [] == sources("#{@fixture_dir}/level1/empty")
    end
    test "sources at level1" do 
      expected = ~w(level1/elixir.ex level1/markdown.md) |> normalized_result()
      assert expected == sources("#{@fixture_dir}/level1") |> Enum.sort()
    end
    test "all sources" do 
      expected =
        ~w(base.ex base1.exs level1/elixir.ex level1/markdown.md) |> normalized_result()
      assert expected == sources(@fixture_dir) |> Enum.sort()
    end
  end

  defp normalized_result files do
    files
    |> Enum.sort()
    |> Enum.map(fn f -> [@fixture_dir, f] |> Enum.join("/") end)
  end

  defp sources(dir) do
    find_source_files(dir)
    |> Enum.sort()
  end
end
