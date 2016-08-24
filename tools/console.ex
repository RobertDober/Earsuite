defmodule Tools.Console do
  @opts %Earmark.Options{}

  @moduledoc """
  Load me inside the console with `c "./tools/console.ex"`
  
  then import me with
      import Tools.Console
  """

  @doc """
  read file and convert code to ast
  """
  def ast_from_file file do 
    with {:ok, ast} <- file
      |> File.read!()
      |> Code.string_to_quoted(),
    do:
      ast
  end

  @doc """
  markdown -> html
  """
  def html markdown do 
    Earmark.to_html markdown
  end

  @doc """
  markdown -> Lines
  """
  def lines markdown do 
    markdown
    |> String.split()
    |> Earmark.Line.scan_lines(@opts, false)
  end

  @doc """
  markdown -> blocks
  """
  def blocks(markdown) do
    markdown
    |> String.split()
    |> Earmark.parse(@opts)
  end

  def parse(markdown) do
    markdown
    |> Earmark.Parser.parse()
  end

  @doc """
  walk a nested list
  """
  def walk(fun, list, acc), do: _walk(fun, list, [], acc)

  def _walk(_fun, [], [], acc), do: acc
  def _walk(fun, [], later, acc), do: _walk(fun, later, [], acc) 
  def _walk(fun, [node|rest], later, acc) when is_list(node) do 
    _walk(fun, node, [rest|later], acc) 
  end
  def _walk(fun, [node|rest], later, acc) do
    _walk(fun, rest, later, fun.(acc, node))
  end
    
end
