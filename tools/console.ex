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
end