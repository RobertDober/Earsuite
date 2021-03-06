defmodule Earsuite.Ast.Parser do

  import Traverse

  # Code:
  # defmodule Outer do
  #   defmodule Inner do
  #     @moduledoc "I am the inner"
  #   end
  #   @moduledoc "I am the outer"
  # end
  # defmodule Other do
  # end
  #
  # AST:
  # {:__block__, [],
  #   [{:defmodule, [line: 1],
  #     [{:__aliases__, [counter: 0, line: 1], [:Outer]},
  #       [do: {:__block__, [],
  #         [{:defmodule, [line: 2],
  #           [{:__aliases__, [counter: 0, line: 2], [:Inner]},
  #             [do: {:@, [line: 3], [{:moduledoc, [line: 3], ["I am the inner"]}]}]]},
  #          {:@, [line: 5], [{:moduledoc, [line: 5], ["I am the outer"]}]}]}]]},    # *After* moduledoc of inner
  #   {:defmodule, [line: 7],
  #     [{:__aliases__, [counter: 0, line: 7], [:Other]}, [do: nil]]}]}
  #
  #  But
  #  ===
  #
  #  Code:
  # defmodule Outer do
  #   @moduledoc "I am the outer"
  #   defmodule Inner do
  #     @moduledoc "I am the inner"
  #   end
  # end
  # defmodule Other do
  # end
  # {:__block__, [],
  #   [{:defmodule, [line: 1],
  #     [{:__aliases__, [counter: 0, line: 1], [:Outer]},
  #       [do: {:__block__, [],
  #         [{:@, [line: 2], [{:moduledoc, [line: 2], ["I am the outer"]}]},    # *Before* moduledoc of inner
  #           {:defmodule, [line: 3],
  #             [{:__aliases__, [counter: 0, line: 3], [:Inner]},
  #               [do: {:@, [line: 4],
  #                 [{:moduledoc, [line: 4], ["I am the inner"]}]}]]}]}]]},
  #    {:defmodule, [line: 7],
  #      [{:__aliases__, [counter: 0, line: 7], [:Other]}, [do: nil]]}]}
  #
  # Code:
  #
  # defmodule TestModule do
  #   @doc "fun 1"
  #   @spec fun1 :: nil
  #   def fun1, do: nil
  #   @doc "fun 2"
  #   @moduledoc "nonsense"
  #   def fun2, do: nil
  # end
  # 
  # {:ok,
  #  {:defmodule, [line: 2],
  #   [{:__aliases__, [counter: 0, line: 2], [:TestModule]},
  #    [do: {:__block__, [],
  #      [{:@, [line: 3], [{:doc, [line: 3], ["fun 1"]}]},
  #       {:@, [line: 4],
  #        [{:spec, [line: 4],
  #          [{:::, [line: 4], [{:fun1, [line: 4], nil}, nil]}]}]},
  #       {:def, [line: 5], [{:fun1, [line: 5], nil}, [do: nil]]},
  #       {:@, [line: 6], [{:doc, [line: 6], ["fun 2"]}]},
  #       {:@, [line: 7], [{:moduledoc, [line: 7], ["nonsense"]}]},
  #       {:def, [line: 8], [{:fun2, [line: 8], nil}, [do: nil]]}]}]]}}
  # 
  @spec extract_docs_from_ast( any ) :: map
  def extract_docs_from_ast(nil), do: %{}
  def extract_docs_from_ast(ast) do
    ast
    |> extract_modules()
  end

  def extract_modules(ast, prefices \\ []) do
    # walk( ast, [], Traverse.Tools.make_trace_fn(&_extract_modules/2) )
    walk( ast, %{}, &(_extract_modules(&1, &2, prefices)) )
  end

  @spec _extract_modules( any, any, list ) :: any
  defp _extract_modules( node, acc, prefices )
  defp _extract_modules( {:defmodule, _, [{:__aliases__, _, [module_name]} | module_ast ] }, acc, prefices ) do
    submodules = extract_modules( module_ast, [module_name | prefices] )
    thisdoc    = extract_this_doc( module_ast )
    fundocs    = extract_function_docs( module_ast )
    thismodulekey = [module_name | prefices]
                    |> Enum.reverse()
                    |> Enum.join( "." )
                    |> String.to_atom()
    %Traverse.Cut{acc: 
      Map.merge( acc, submodules )
      |> Map.put( thismodulekey, %{moduledoc: thisdoc, docs: fundocs} )
    }
  end
  defp _extract_modules(_, acc, _), do: acc

  defp extract_function_docs(moduleast), do: walk(moduleast, %{}, &_extract_function_docs/2)

  defp _extract_function_docs( {:__block__, _, definitions}, _), do: cut(collect_function_docs(definitions))
  defp _extract_function_docs(_, acc), do: acc

  defp collect_function_docs(definitions) do
    case walk(definitions, [], &_collect_function_docs/2) do
      [{_tangling_doc} | rest] -> rest
      docs                     -> docs
    end |>
      Enum.into(%{})
  end

  defp _collect_function_docs({:@, _, [{:moduledoc, _, _}]}, acc), do: cut(acc)

  # Meeting a doc string after an unconsumed docstring
  defp _collect_function_docs({:@, _, [{:doc, _, [doc]}]}, [{_doc}|rest]) do
    # Shall we warn, as the compiler would?
    [{doc}|rest]
  end
  # sigilled docstring after an unconsumed docstring
  defp _collect_function_docs({:@, _, [{:doc, _, [{:sigil_s, _, [{:<<>>, _, [doc]}, _]}]}]}, [{_doc}|rest]) do
    # Shall we warn, as the compiler would?
    [{doc}|rest]
  end
  defp _collect_function_docs({:@, _, [{:doc, _, [{:sigil_s, _, [{:<<>>, _, [doc]}, _]}]}]}, acc) do
    [{doc}|acc]
  end
  defp _collect_function_docs({:@, _, [{:doc, _, [doc]}]}, acc) do
    [{doc}|acc]
  end
  # Meeting a function definition after an unconsumed docstring, great!
  defp _collect_function_docs({:def, _, [{fn_name, _, _}|_]}, [{doc}|rest]) do
    [{fn_name, doc}|rest]
  end
  defp _collect_function_docs(_, acc), do: acc

  defp extract_this_doc(moduleast), do: walk(moduleast, nil, &_extract_this_doc/2)

  defp _extract_this_doc({:@, _, [{:moduledoc, _, [{:sigil_s, _, [{:<<>>, _, [moduledoc]}, _]}]}]}, _acc ),
   do: cut(moduledoc)
  defp _extract_this_doc({:@, _, [{:moduledoc, _, [moduledoc]}]}, _acc), do: cut(moduledoc)
  defp _extract_this_doc( {:defmodule, _, _}, acc), do: cut(acc)
  defp _extract_this_doc(_, acc), do: acc
  
  defp cut(acc), do: %Traverse.Cut{acc: acc}
end
