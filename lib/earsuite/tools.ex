defmodule Earsuite.Tools do

    @default_spec_dir "specs"
    @elixir_rgx       ~r{\.exs?$}
    @markdown_rgx     ~r{\.md$}
    @source_rgx       ~r{\.exs?$|\.md$}

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
    Find all files matching `~r{\.md|\.exs?$}` recursively in `dir`
    """
    def find_source_files(dir) do
      find_files_in_dir(dir, @source_rgx)
    end

    @doc """
    Associate files to a stream of files
    """
    def associate_files(file_stream, assoc_fun) do
      Stream.map(file_stream, assoc_fun)
    end

    def associated_file(source_file) do
      cond do
        elixir_file?(source_file)   -> Regex.replace(@elixir_rgx, source_file, ".md")
        markdown_file?(source_file) -> Regex.replace(@markdown_rgx, source_file, ".html")
      end
    end

    def find_specs(dir) do
      find_source_files(dir)
      |> associate_files(&make_spec_tuple/1)
    end

    def make_spec_tuple(file) do
      with alt_file = file |> associated_file(),
      do:
        {file, File.exists?(alt_file) && alt_file}
    end

    defp elixir_file?(fun), do: Regex.match?( @elixir_rgx, fun)
    defp markdown_file?(fun), do: Regex.match?( @markdown_rgx, fun)
end
