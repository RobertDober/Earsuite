defmodule Fn.Regex do
  @moduledoc """
  Exposes functions of Regex as Higher Order Functions (curried) and with more readable names.
  """

  @doc """
  Currieed replace with pattern only:

      iex> replace(~r{[A-Z]}).("AlphaCentauri", "*")
      "*lpha*entauri"
  """
  def replace(pattern_rgx), do:
    fn source, replacement -> Regex.replace(pattern_rgx, source, replacement) end

  @doc """
  Curried replace with pattern and source:

      iex> replace_in(~r{(\\d+)}, "R2D2").("\\\\1\\\\1")
      "R22D22"
  """
  def replace_in(pattern_rgx, source), do:
    fn replacement -> Regex.replace(pattern_rgx, source, replacement) end

  @doc """
  Curried replace with pattern and replacement:

      iex> replace_with(~r{\\.[^\\.]*$}, "").("a.b.c")
      "a.b"

      iex> ~w(a.b a.b.c)
      ...> |> Enum.map(replace_with(~r{\\.[^.]*$}, ""))
      ~w(a a.b)
  """
  def replace_with(pattern_rgx, replacement), do:
    fn source -> Regex.replace(pattern_rgx, source, replacement) end
end
