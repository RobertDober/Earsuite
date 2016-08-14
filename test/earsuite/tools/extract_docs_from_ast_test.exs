defmodule Earsuite.Tools.ExtractDocsFromAstTest do
  use ExUnit.Case

  import Earsuite.Ast.Parser, only: [extract_docs_from_ast: 1]

  @empty_module """
  defmodule Empty, do: nil
  """
  @documented_module """
    defmodule Documented do
      @moduledoc "moduledoc of Documented"
    end
  """

  @two_modules """
    defmodule One, do: nil
    defmodule Two do
      @moduledoc "moduledoc of Two"
    end
  """

  @module_with_code """
    defmodule WithCode do
      @moduledoc "moduledoc of WithCode"
      def code, do: :code
    end
  """
  test "no docs" do 
    assert [] == from_string("") 
  end

  test "still no docs" do 
    assert [ %{name: :Empty, moduledoc: nil, docs: []}] == from_string(@empty_module)
  end

  test "documented module" do 
    assert [%{module: %{name: :Documented, moduledoc: "moduledoc of Documented", docs: [] }}] == from_string @documented_module
  end
  test "two modules" do 
    assert [ %{name: :One, moduledoc: nil, docs: []},
             %{name: :Two, moduledoc: "moduledoc of Two", docs: []}] == from_string @two_modules
  end

  defp from_string code do
    with {:ok, ast} <- Code.string_to_quoted(code),
    do:
      extract_docs_from_ast(ast)
  end
end