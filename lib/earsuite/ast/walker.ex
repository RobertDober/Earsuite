defmodule Earsuite.Ast.Walker do
  
  @moduledoc """
  Convenience methods to walk Ast like sructures (really any datasytructure mixing lists and tuples)
  """

  @doc """
  A convenience function to use `Macro.prewalk` with a simple accumulator
  function. For details refer to the almost symmetrical function `pre_walk`.

  They are behaving identically (as we always return the whole ast-node inside `walker`).
  """
  def post_walk( ast, acc, fun) do 
    with {_ast, result} <- Macro.postwalk( ast, acc, walker(fun)),
    do: result
  end

  @doc """
  A convenience function to use `Macro.prewalk` with a simple accumulator
  function. This is useful where we do not need to construct a new ast, as e.g.
  in writing macros but want to explore or transform the ast for some other
  reasons.

  Also note that this does not allow to _cut_ the ast as you could by using `Macro.prewalk`
  as you cannot return modified ast to `Macro.prewalk` as we will **alwyas** return the current
  ast node.

  Example:
        # extract line numbers of calls of `pre_walk`
        pre_walk( some_ast, [], fn {:pre_walk, [line: l], _}, acc -> [l|acc]
                                   _, acc                         -> acc
                                end) |> Enum.reverse()

  is essentially the same as:
        Macro.prewalk( some_ast, [], fn node, {:pre_walk, [line: l], _}, acc -> {node, [l|acc]}
                                        node, _, acc                         -> {node, acc}
                                end) |> Enum.reverse()
  """
  def pre_walk( ast, acc, fun) do 
    with {_ast, result} <- Macro.prewalk( ast, acc, walker(fun)),
    do: result
  end

  defp walker(fun) do 
    fn node, acc ->
      {node, fun.(node, acc)}
    end
  end
end
