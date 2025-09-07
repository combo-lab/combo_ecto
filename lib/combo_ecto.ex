defmodule Combo.Ecto do
  @moduledoc """
  Provides Ecto integration for Combo.
  """
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, name: Combo.Ecto.SQL.SandboxSupervisor, strategy: :one_for_one}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Combo.Ecto.Supervisor)
  end
end
