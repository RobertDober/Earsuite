defmodule Support.RunSpecs do


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

end
