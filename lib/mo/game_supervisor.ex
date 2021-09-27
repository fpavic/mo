defmodule Mo.GameSupervisor do
  use Supervisor

  def start_link(args \\ []) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    children = [
      {Registry, keys: :unique, name: Mo.PlayerRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: Mo.PlayerSupervisor},
      {Mo.Game, []}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
