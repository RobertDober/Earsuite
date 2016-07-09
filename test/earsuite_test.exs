defmodule EarsuiteTest do
  use ExUnit.Case
  doctest Earsuite

  import Earsuite.Tools, only: [find_spec_pairs: 0]
  import Support.RunSpecs

  # TODO: Filter html_file false in find_spec_pairs()
  find_spec_pairs()
  |> Enum.each(fn {_, false} -> nil
                  {md_file, html_file} ->
    test md_file do
      # FIXME:
      # This needs to become an intelligent, modifiabel structural comparision
      # with readable diff error messages !
      assert render_and_parse(unquote(md_file)) == parse(unquote(html_file))
    end
  end)



end
