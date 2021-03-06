Code.eval_file "tasks/make_specs.exs"

defmodule Earsuite.Mixfile do
  use Mix.Project

  def project do
    [app:             :earsuite,
     version:         "0.1.0",
     elixir:          "~> 1.3",
     elixirc_paths:   elixirc_paths(Mix.env),
     build_embedded:  Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:earmark, "1.0.1"},
      {:floki,  "0.9.0"},
      {:traverse,  "~> 0.1"},
      {:excoveralls, "~> 0.5", only: :test},
      {:mock, "~> 0.1", only: :test},
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support", "test/assets"]
  defp elixirc_paths(_),     do: ["lib"]

end
