defmodule Runner do 
  import Earsuite.Ast.Walker
  import Earsuite.Tools, only: [ast_from_file: 1]

  def run do
    ast = ast_from_file(System.argv|>Enum.join())

    # IO.inspect ast
    # post_walk(ast, nil, show_line)
    Macro.prewalk(ast, nil, fn
      {:def, _, _}, acc -> 
        IO.inspect :def
      node={_, [line: l], _}, acc ->
        IO.inspect l
        {node, acc}
        {[], acc}
      node, acc         -> {node, acc} 
    end)

  end

  def show_line do 
    fn {_, [line: l], _}, _ ->
      IO.inspect l
      _, _ -> nil
    end
  end

end

Runner.run
