defmodule EarmarkRegression.EarsuiteTest do
  use ExUnit.Case
  doctest Earsuite

  import Earsuite.Tools, only: [find_specs: 1]
  import Support.RunSpecs

  # TODO: Filter html_file false in find_spec_pairs()
  find_specs("specs") 
  |> Enum.each(fn {_, _, nil} -> nil
                  {_, nil, _}   -> nil
                  {_, md_file, html_file} ->
    test md_file do
      # FIXME:
      # This needs to become an intelligent, modifiabel structural comparision
      # with readable diff error messages !
      assert render_and_parse(unquote(md_file)) == parse(unquote(html_file))
    end
  end)



end
