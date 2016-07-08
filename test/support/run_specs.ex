defmodule Support.RunSpecs do

  @groupreg ~r{\.md$}

  def get_specs do 
    @groupreg
    |> Regex.source()
    |> to_char_list()
    |> find_files()
    |> make_pairs()
  end

  def render_and_parse(md_file) do 
    md_file
    |> File.read!()
    |> Earmark.to_html()
    |> Floki.parse()
  end

  def parse(html_file) do 
    html_file
    |> File.read!()
    |> Floki.parse()
  end

  defp find_files(filter, recursive \\ true) do 
    :filelib.fold_files( 'specs', filter, recursive, fn x, a -> [to_string(x)|a] end, [] )
  end

  defp make_pairs(file_list) do 
    file_list
    |> Enum.map(&make_pair/1)
    |> Enum.filter(&remove_orphans/1)
  end

  defp make_pair(file) do 
    with alt_file = Regex.replace(@groupreg, file, ".html"), do:
      {file, (File.exists?(alt_file) && alt_file)} 
  end

  defp remove_orphans({file, false}) do
    IO.puts(:stderr, "warn no .html present for file: #{file}")
    false
  end
  defp remove_orphans(_), do: true
end
