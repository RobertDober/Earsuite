defmodule Earsuite do

  import Earsuite.Tools, only: [emit_colorized: 1, associate_html_file: 1, find_spec_pairs: 1]

  @doc """
  """
  @spec make_specs( String.t() ) :: boolean()
  def make_specs(from_path) do
    from_path
    |> find_spec_pairs() 
    |> Stream.filter(fn {_,x} -> !x end)
    |> Stream.map(&make_spec/1)
    |> Stream.run()
  end

  defp generate_html_file(md_file, html_file) do 
    with html = md_file |> File.read!() |> Earmark.to_html() do
      File.write!(html_file, html)
      emit_colorized(["Html spec ", :green, html_file, :reset, " created"])
    end
  end

  defp make_spec {md_file, false} do 
    with html_file = md_file |> associate_html_file(),
    do:
      generate_html_file(md_file, html_file)
  end
end
