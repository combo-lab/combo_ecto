# Combo.Ecto

Provides Ecto integration for Combo.

## Features

- implements `Combo.HTML.FormData` protocol for `Ecto.Changeset`
- implements `Plug.Exception` protocol for the relevant Ecto exceptions
- provides plugs for concurrent browser tests

## Installation

Add `:combo_ecto` to the list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:combo_ecto, "~> 0.1"}]
end
```

## About concurrent browser tests

This package provides a plug called `Combo.Ecto.SQL.Sandbox` that allows developers to run acceptance tests powered by headless browsers such as ChromeDriver and Selenium concurrently. If you are not familiar with Ecto's SQL sandbox, we recommend you to first get acquainted with it by [reading `Ecto.Adapters.SQL.Sandbox` documentation](https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html).

To enable concurrent acceptance tests, make sure you are using PostgreSQL and follow the instructions below:

1. Set a flag to enable the sandbox in `config/test.exs`:

```elixir
config :demo, sql_sandbox: true
```

2. And use the flag to conditionally add the plug to `lib/demo/web/endpoint.ex`:

```elixir
if Application.get_env(:demo, :sql_sandbox) do
  plug Combo.Ecto.SQL.Sandbox
end
```

Make sure that this is placed **before** the line of `plug Demo.Web.Router` (or any other plug that may access the database).

You can now checkout a sandboxed connection and pass the connection information to an acceptance testing tool like [Hound](https://github.com/hashnuke/hound) or [Wallaby](https://github.com/elixir-wallaby/wallaby).

### Hound

To write concurrent acceptance tests with Hound, first add it as a dependency to your `mix.exs`:

```elixir
{:hound, "~> 1.0"}
```

Make sure to start it at the top of your `test/test_helper.exs`:

```elixir
{:ok, _} = Application.ensure_all_started(:hound)
```

Then add the following to your test case (or case template):

```elixir
use Hound.Helpers

setup tags do
  pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Demo.Core.Repo, shared: not tags[:async])
  on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  metadata = Combo.Ecto.SQL.Sandbox.metadata_for(Demo.Core.Repo, pid)
  Hound.start_session(metadata: metadata)
  :ok
end
```

Hound supports multiple drivers like Chrome, Firefox, etc but it does not support concurrent tests under PhantomJS (the default).

### Wallaby

To write concurrent acceptance tests with Wallaby, first add it as a dependency to your `mix.exs`:

```elixir
{:wallaby, "~> 0.25", only: :test}
```

Wallaby can take care of setting up the Ecto Sandbox for you if you use `use Wallaby.Feature` in your test module.

```elixir
defmodule MyAppWeb.PageFeature do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  feature "shows some text", %{session: session} do
    session
    |> visit("/home")
    |> assert_text("Hello world!")
  end
end
```

If you don't `use Wallaby.Feature`, you can add the following to your test case (or case template):

```elixir
use Wallaby.DSL

setup tags do
  pid = Ecto.Adapters.SQL.Sandbox.start_owner!(Demo.Core.Repo, shared: not tags[:async])
  on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  metadata = Combo.Ecto.SQL.Sandbox.metadata_for(Demo.Core.Repo, pid)
  {:ok, session} = Wallaby.start_session(metadata: metadata)
end
```

Wallaby currently supports ChromeDriver and Selenium, allowing testing in almost any browser.

## Configuration

The `Plug.Exception` implementations for Ecto exceptions may be disabled by including the error in the mix configuration.

```elixir
config :combo_ecto,
  exclude_ecto_exceptions_from_plug: [Ecto.NoResultsError]
```

## License

Same as Combo.
