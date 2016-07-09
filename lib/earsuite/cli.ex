defmodule Earsuite.Cli do

  def main(argv) do
    argv 
    |> parse_args() 
    |> process()
  end

  @usage """
  usage:

    make_specs [OPTIONS]

  Using current version of Earmark make spec pairs of Markdown (.md) and
    expected HTML (.html) files.

    -h  | --help    print this text to stdout and exit
    -v  | --version print current version to stdout and exit
  """
  defp parse_args(argv) do 
  argv
  |> parse_options()
  |> process()

  end

  defp parse_options(argv) do
    with switches = [ help: :boolean, version: :boolean, ],
      aliases  = [ h: :help, v: :version, ],
    do:  OptionParser.parse(argv, strict: switches, aliases: aliases)
  end

  defp process(parsed_options) do 
    case parsed_options do 
    {[help: true],_,_} -> IO.puts(:stderr, @usage)
    {[version: true],_,_} -> _process(:version)
    {_,_,[]}              -> _process(:specs)
    {_, _, errors}     ->    _process(:errors, errors)
    _                  -> nil
    end
  end

  defp _process(type, data \\ [])
  defp _process(:specs, _), do: Earsuite.make_specs("specs")
  defp _process(:help,_), do: IO.puts(@usage)

  defp _process(:version, _) do 
    {:ok, version} = :application.get_key(:earsuite, :vsn)
    IO.puts(version)
  end

  defp _process(:errors, errors) do 
    IO.puts(:stderr, "ERROR: Illegal params:")
    IO.puts(:stderr, inspect(errors))
    _process(:help)
  end
end
