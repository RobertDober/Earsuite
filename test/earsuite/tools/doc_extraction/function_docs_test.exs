defmodule Earsuite.Tools.DocExtraction.FunctionDocsTest do
  
  use ExUnit.Case

  import Earsuite.Ast.Parser, only: [extract_docs_from_ast: 1]

  @mixed """
  defmodule Mixed do
    # Literal sigil_s's are ok
    @moduledoc ~s<the module>
    # A standard doc
    @doc "one"
    def one, do: nil
    def two, do: nil
    # A sigilled doc
    @doc ~s<three>
    def three, do: nil
    # A tangling doc
    @doc "four"
  end
  """
  test "mixed" do 
    assert %{ Mixed: %{moduledoc: "the module",
                       docs: %{one: "one", three: "three"}}} = from_string(@mixed)
  end

  test "check" do 
    assert %{ TestModule: %{moduledoc: nil, docs: %{two: "doc for two"}}
    } = make_module_code( functions: [one: false, two: true, three: false] )
        |> from_string()
  end

  @module_template """
  defmodule TestModule do
    <%= moduledoc %>
    <%= makefns.(functions) %>
  end
  """
  defp make_functions functions do 
    functions
    |> Enum.flat_map( fn {name, docced} -> 
        [ (if docced, do: "  @doc ~s(doc for #{name})"),
          "  def #{name}, do: :#{name}" ] end)
    |> Enum.join("\n")
  end
  defp make_module_code options do 
    options = Keyword.merge([
      moduledoc: nil,
      functions: [one: true],
      makefns: &make_functions/1,
      ], options)
    EEx.eval_string @module_template, options
  end
  defp from_string code do
    with {:ok, ast} <- Code.string_to_quoted(code),
    do:
      extract_docs_from_ast(ast)
  end
end
