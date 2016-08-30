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
  def extract_docs_from_ast(nil), do: []
  def extract_docs_from_ast(ast) do 
    ast
    |> extract_modules()
    |> List.flatten()
    |> Enum.reverse()
    # |> Enum.filter_map(&filter_module?/1, &parse_module/1)
  end

  def extract_modules(ast) do
    # walk( ast, [], Traverse.Tools.make_trace_fn(&_extract_modules/2) )
    walk( ast, [], &_extract_modules/2 )
  end

  @spec _extract_modules( any, any ) :: any
  defp _extract_modules( node, acc )
  defp _extract_modules( {:defmodule, _, [{:__aliases__, _, [module_name]} | _ ] }, acc ),
    do: [ %{name: module_name} | acc ] dafezafez  
  defp _extract_modules(_, acc), do: acc
end
