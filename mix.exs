defmodule Combo.Ecto.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @description "Provides Ecto integration for Combo."
  @source_url "https://github.com/combo-team/combo_ecto"
  @changelog_url "https://github.com/combo-team/combo_ecto/blob/v#{@version}/CHANGELOG.md"

  def project do
    [
      app: :combo_ecto,
      version: @version,
      elixir: "~> 1.15",
      deps: deps(),
      description: @description,
      source_url: @source_url,
      homepage_url: @source_url,
      docs: docs(),
      package: package(),
      aliases: aliases()
    ]
  end

  def application do
    [
      mod: {Combo.Ecto, []},
      extra_applications: [:logger],
      env: [exclude_exceptions: []]
    ]
  end

  defp deps do
    [
      {:combo, path: "../combo", optional: true},
      {:ecto, "~> 3.5"},
      {:plug, "~> 1.9"},
      {:postgrex, "~> 0.16", optional: true},
      {:ex_check, ">= 0.0.0", only: [:dev], runtime: false},
      {:credo, ">= 0.0.0", only: [:dev], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false}
    ]
  end

  defp docs do
    [
      extras: ["README.md", "CHANGELOG.md"],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "Changelog" => @changelog_url
      }
    ]
  end

  defp aliases do
    [publish: ["hex.publish", "tag"], tag: &tag_release/1]
  end

  defp tag_release(_) do
    Mix.shell().info("Tagging release as v#{@version}")
    System.cmd("git", ["tag", "v#{@version}"])
    System.cmd("git", ["push", "--tags"])
  end
end
