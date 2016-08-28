defmodule Earsuite.Tools do

    @default_spec_dir "specs/Markdown"
    @markdown_rgx     ~r{\.md$}

    @doc false
    def emit_colorized ansi_and_bins do
      ansi_and_bins
      |> IO.ANSI.format(true)
      |> IO.iodata_to_binary()
      |> IO.puts()
    end


    def ast_from_file(file) do
      file |> File.read!() |> ast_from_string()
    end

    def ast_from_string(str) do 
      with {:ok, ast} <- Code.string_to_quoted(str),
      do: ast
    end

    def extract_markdown_from_file(file) do 
    IO.inspect file
      file
      |> ast_from_file()
      |> Earsuite.Ast.Parser.extract_docs_from_ast()
    end

    @doc """
      Find files in the `dir` directory that match the `filter` regexp (only the file's basename, not
      the whole path, is matched). Recurse into subdirs unless `recursive` is `false`. Defaults to `true`.
    """
    def find_files_in_dir(dir, filter, recursive \\ true) do
      with dir    = dir |> to_char_list(),
           filter = filter |> Regex.source() |> to_char_list(),
       do:
         :filelib.fold_files( dir, filter, recursive, fn x, a -> [to_string(x)|a] end, [] )
    end

    @doc """
    Find all files matching `~r{\.md$}` recursively in `dir`
    """
    def find_md_files(dir \\ @default_spec_dir) do
      find_files_in_dir(dir, @markdown_rgx)
    end

    @doc """
    Associate files to a stream of files
    """
    def associate_files(file_stream, assoc_fun) do
      Stream.map(file_stream, assoc_fun)
    end

    def associate_html_file(md_file) do
      Regex.replace(@markdown_rgx, md_file, ".html")
    end

    def find_spec_pairs(dir \\ @default_spec_dir) do
      find_md_files(dir)
      |> associate_files(&make_spec_pair/1)
    end

    def make_spec_pair(file) do
      with alt_file = file |> associate_html_file(),
      do:
        {file, File.exists?(alt_file) && alt_file}
    end
end
