defmodule Earsuite do

  import Earsuite.Tools, only: [emit_colorized: 1, associated_file: 1, find_specs: 1]

  @type maybe_filename :: binary | nil

  @doc """
  Entry function of the homonymous mix task.
  """
  @spec make_specs( String.t() ) :: boolean()
  def make_specs(from_path) do
    from_path
    |> find_specs()
    |> Stream.map(&make_spec/1)
    |> Stream.run()
  end


  defp generate_md_file(ex_file, _md_file) do
    ex_file
    |> File.read!()
    |> Code.string_to_quoted()
    |> IO.inspect()

  end

  defp generate_html_file(md_file, html_file) do
    with html = md_file |> File.read!() |> Earmark.to_html() do
      File.write!(html_file, html)
      emit_colorized(["Html spec ", :green, html_file, :reset, " created"])
    end
  end

  @spec make_spec( {maybe_filename, maybe_filename, maybe_filename} ) :: any
  defp make_spec( {_, _, html_file} ) when is_binary(html_file),
    do: emit_colorized(["refusing to clobber", :yellow, html_file, :reset])

  defp make_spec {nil, md_file, nil} do
    with html_file <- md_file |> associated_file(),
    do: generate_html_file(md_file, html_file)
  end

  defp make_spec( {_, md_file, nil} ) when is_binary(md_file),
    do: emit_colorized(["refusing to clobber", :yellow, md_file, :reset])

  defp make_spec {ex_file, nil, nil} do
    with md_file <- ex_file |> associated_file() do
      generate_md_file(ex_file, md_file)
      |> generate_html_file( ex_file |> associated_file() )
    end
  end
end
