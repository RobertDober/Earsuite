defmodule Earsuite.Tools.ExtractModulesTest do
  use ExUnit.Case

 import Earsuite.Ast.Parser, only: [extract_modules: 1]

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

  test "empty" do 
    assert [] == from_string("")
  end

  defp from_string code do
    with {:ok, ast} <- Code.string_to_quoted(code),
    do:
      extract_modules(ast)
  end
end
