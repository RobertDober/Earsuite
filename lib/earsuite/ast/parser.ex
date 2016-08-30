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
  defp _extract_modules( node, acc, prefices \\ [] )
  defp _extract_modules( {:defmodule, _, [{:__aliases__, _, [module_name]} | module_ast ] }, acc, prefices ) do
    submodules = extract_modules( module_ast, [module_name | prefices] )
    thisdoc    = extract_this_doc( module_ast )
    thismodulekey = [module_name | prefices]
                    |> Enum.reverse()
                    |> Enum.join( "." )
                    |> String.to_atom()
    %Traverse.Cut{acc: 
      Map.merge( acc, submodules )
      |> Map.put( thismodulekey, %{moduledoc: thisdoc, docs: []} )
    }
  end
  defp _extract_modules(_, acc, _), do: acc


  defp extract_this_doc(moduleast), do: walk(moduleast, nil, &_extract_this_doc/2)

  defp _extract_this_doc({:@, _, [{:moduledoc, _, [moduledoc]}]}, _acc), do: %Traverse.Cut{acc: moduledoc}
  defp _extract_this_doc(_, _), do: nil
  
end
