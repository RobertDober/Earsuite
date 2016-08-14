defmodule Earsuite.Ast.Parser do

    def extract_docs_from_ast(nil), do: []
    def extract_docs_from_ast(ast) do 
      ast 
      |> extract_modules()
      |> List.flatten()
      |> Enum.reverse()
      # |> Enum.filter_map(&filter_module?/1, &parse_module/1)
    end

    def extract_modules(ast), do: _extract_modules(ast, [])

    defp _extract_modules(nil, _), do: []
    defp _extract_modules(module_ast={:defmodule, _, _}, result) do
      [module_ast | result]
    end

    defp _extract_modules({:__block__, _, list}, result) do
      with modules = Enum.map(list, &extract_modules/1),
      do: [modules | result]
    end

    # defp parse_module(ast, options \\ %{}) 
    # defp parse_module({:defmodule, [line: line], [{:__aliases__, _, [modulename]}, do_body]}, opts) do 
    #   parse_do(do_body, Map.put_new(opts, name: modulename))
    # end

    # defp parse_do([do: {:__block__, _, elements}], opts) do 
    #   elements
    #   |> Enum.filter(&module_doc?/1)
    #   |> Enum.map(&parse_do_element/1)
    # end

    # defp parse_module_doc([{:moduledoc, _, [doc]}], opts) do 
    #   doc
    # end

    # defp parse_module_doc(_, _opts), do: nil

    # defp parse_docs(result, _ast), do: result
end
