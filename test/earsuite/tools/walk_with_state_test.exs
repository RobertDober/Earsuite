defmodule Earsuite.Tools.WalkerTest do
  use ExUnit.Case

  import Earsuite.Ast.Walker

  defp fn_acc_only, do: fn _, a -> a end
  defp fn_count_nodes, do: fn _, a -> a + 1 end
  defp fn_doc_only, do:
    fn mdoc = {:moduledoc, _, _}, a -> [mdoc|a]
       doc = {:doc, _, _}, a        -> [doc|a]
       _, a                            -> a
    end

  test "empty" do 
    assert :pass = post_walk([], :pass, fn_acc_only)
    assert :pass = pre_walk([], :pass, fn_acc_only)
  end

  @ast {:defmodule, [line: 1],
    [{:__aliases__, [counter: 0, line: 1], [:A]},
     [do: {:__block__, [],
       [{:@, [line: 2], [{:moduledoc, [line: 2], ["A"]}]},
       {:@, [line: 4], [{:doc, [line: 4], ["f"]}]},
       {:def, [line: 5], [{:f, [line: 5], nil}, [do: nil]]}]}]]}

  describe "not empty" do
    test "but filtered" do 
      assert [] = post_walk( @ast, [], fn_acc_only)
      assert [] = pre_walk( @ast, [], fn_acc_only)
    end
    test "but less filtered" do 
      assert [{:moduledoc, [line: 2], ["A"]},
       {:doc, [line: 4], ["f"]}] = post_walk( @ast, [], fn_doc_only ) |> Enum.reverse()

      assert [{:moduledoc, [line: 2], ["A"]},
       {:doc, [line: 4], ["f"]}] = pre_walk( @ast, [], fn_doc_only ) |> Enum.reverse()
    end
    test "counting nodes" do 
      assert 19 = post_walk( @ast, 0, fn_count_nodes )
      assert 19 = pre_walk( @ast, 0, fn_count_nodes )
    end
  end

end
