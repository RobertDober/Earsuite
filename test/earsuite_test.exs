defmodule EarsuiteTest do
  use ExUnit.Case
  doctest Earsuite

  import Support.RunSpecs

  get_specs()
  |> Enum.each(fn {md_file, html_file} ->
    test md_file do
      # FIXME:
      # This needs to become an intelligent, modifiabel structural comparision
      # with readable diff error messages !
      assert render_and_parse(unquote(md_file)) == parse(unquote(html_file))
    end
  end)



end
