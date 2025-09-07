# Combo.Ecto

[![CI](https://github.com/combo-team/combo_ecto/actions/workflows/ci.yml/badge.svg)](https://github.com/combo-team/combo_ecto/actions/workflows/ci.yml)
[![Hex.pm](https://img.shields.io/hexpm/v/combo_ecto.svg)](https://hex.pm/packages/combo_ecto)

Provides Ecto integration for Combo.

## Features

- implements `Plug.Exception` protocol for the relevant Ecto exceptions
- implements `Combo.HTML.FormData` protocol for `Ecto.Changeset`
- provides `Combo.Ecto.SQL.Sandbox` plug for concurrent browser tests

## Installation

Add `:combo_ecto` to the list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:combo_ecto, "<requirement>"}
  ]
end
```

## Configuration

The `Plug.Exception` implementations for Ecto exceptions can be disabled by including the errors in the mix configuration.

```elixir
config :combo_ecto,
  exclude_exceptions: [Ecto.NoResultsError]
```

## License

Same as [Combo](https://github.com/combo-team/combo).
