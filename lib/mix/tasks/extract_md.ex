defmodule Mix.Tasks.ExtractMd do
  use Mix.Task

  import Earsuite.Tools, only: [find_files_in_dir: 2] 
  @shortdoc "Extract md files for each doc block in an Elixir source file"

  def run(_args) do 
    find_files_in_dir("specs/Code", ~r{\.ex$})
    |> Enum.each(&Earsuite.Tools.extract_markdown_from_file/1)
  end
  
end
