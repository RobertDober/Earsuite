defmodule Earsuite.Tools.FindFileTest do
  use ExUnit.Case

  import Earsuite.Tools, only: [find_files_in_dir: 2]

  @fixture_dir "test/fixtures/find_files"

  describe "find_files_in_dir (testing correct application of Erlang's filelib)" do
    test "complex regex" do 
      expected = 
        ~w(base.ex base1.exs both.ex both.exs both.md level1/elixir.ex level1/markdown.md) |> normalized_result()
      assert expected == find(~r{\.md$|\.exs?$}) 
    end
    test "check missed hits above are present" do 
      expected = 
        ~w(base.ex base1.exs base.html base2.html both.ex both.exs both.md wild.md.not level1/other level1/other.html level1/elixir.ex level1/empty/.gitkeep level1/markdown.md)
        |> normalized_result()
      assert expected == find(~r{.})
    end
    test "negative" do
      assert [] == find(~r{xxx})
    end
  end


  defp find rgx do
    find_files_in_dir(@fixture_dir, rgx)
    |> Enum.sort()
  end

  defp normalized_result files do
    files
    |> Enum.sort()
    |> Enum.map(fn f -> [@fixture_dir, f] |> Enum.join("/") end)
  end

end
