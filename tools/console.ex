defmodule Tools.Console do
  @opts %Earmark.Options{}

  @moduledoc """
  Load me inside the console with `c "./tools/console.ex"`
  
  then import me with
      import Tools.Console
  """

  @doc """
  markdown -> html
  """
  def html markdown do 
    Earmark.to_html markdown
  end

  @doc """
  markdown (gfm) -> html
  """
  def gfm markdown do
    Earmark.to_html markdown, %Earmark.Options{gfm: true}
  end

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

  @doc """
  markdown -> blocks - context
  """
  def blox markdown do 
    with {blox, _} <- blocks( markdown ), do: blox 
  end

  def parse(markdown) do
    markdown
    |> Earmark.Parser.parse(@opts)
  end
end
