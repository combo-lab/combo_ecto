# Combo.Ecto

Provides Ecto integration for Combo.

## Features

- implements `Plug.Exception` protocol for the relevant Ecto exceptions
- implements `Combo.HTML.FormData` protocol for `Ecto.Changeset`
- provides `Combo.Ecto.SQL.Sandbox` plug for concurrent browser tests

## Installation

Add `:combo_ecto` to the list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:combo_ecto, "~> 0.1"}]
end
```

## Configuration

The `Plug.Exception` implementations for Ecto exceptions can be disabled by including the errors in the mix configuration.

```elixir
config :combo_ecto,
  exclude_exceptions: [Ecto.NoResultsError]
```

## License

Same as Combo.
