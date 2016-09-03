defmodule Mix.Tasks.MakeSpecs do
  use Mix.Task

  @shortdoc "create html files from markdown and elixir files with current version of Earmark"

  @moduledoc """
  Run this task and for each Markdown file a corresponding Html file will be created under `specs/Markdown`.
  
  Furthermore for each Elixir source file a corresponding Html file will be created under `specs/Code`.

  The Html files are created with the current version of Earmark and can be used as a reference spec for future
  versions of Earmark.

  The reference docs can be checked with the command

  `mix test --only earmark_regression`.
  """

  def run([]), do: run(~w(.))
  def run([dir|_]) do 
    Mix.shell.info "#{dir}"
    Earsuite.make_specs(dir)
  end

end
