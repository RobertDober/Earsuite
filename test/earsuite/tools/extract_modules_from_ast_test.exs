defmodule Earsuite.Tools.ExtractModulesFromAstTest do
  use ExUnit.Case

  import Earsuite.Ast.Parser, only: [extract_modules: 1]

  @ast {:__block__, [],

   [{:defmodule, [line: 1],
     [{:__aliases__, [counter: 0, line: 1], [:Outer]},
      [do: {:__block__, [],
        [{:defmodule, [line: 2],
          [{:__aliases__, [counter: 0, line: 2], [:Inner]},
           [do: {:__block__, [],
             [{:@, [line: 3], [{:moduledoc, [line: 3], ["Inner"]}]},
              {:defmodule, [line: 4],
               [{:__aliases__, [counter: 0, line: 4], [:Innerst]},
                [do: {:@, [line: 5],
                  [{:moduledoc, [line: 5], ["Innerst"]}]}]]}]}]]},
         {:defmodule, [line: 9],
          [{:__aliases__, [counter: 0, line: 9], [:AlsoInner]},
           [do: {:@, [line: 10], [{:moduledoc, [line: 10], ["AlsoInner"]}]}]]},
         {:@, [line: 12], [{:moduledoc, [line: 12], ["Outer"]}]}]}]]},
    {:defmodule, [line: 15],
     [{:__aliases__, [counter: 0, line: 15], [:Flat]},
      [do: {:@, [line: 16], [{:moduledoc, [line: 16], ["Flat"]}]}]]}]}

  @moduletag :wip
  describe "only module part" do
    @tag :wip
    test "module structure" do
      modules = extract_modules(@ast)
      assert [{:Outer, %{modules: [{:Inner, %{modules: [{:Innerst, %{modules: []}}]}},
                            {:AlsoInner, %{modules: []}}]}},
          {:Flat, %{modules: []}}] = modules, modules
    end


  end
end
