defmodule Mo.Player do
  use GenServer

  defmodule State do
    defstruct [
      :position,
      :status,
      :name
    ]
  end

  def start_link(options) do
    name = Keyword.get(options, :hero_name)
    GenServer.start_link(__MODULE__, name, options)
  end

  def init(hero_name) do
    new_position = calculate_position()
    state = %State{status: :alive, position: new_position, name: hero_name}
    Mo.Game.notify(:hero_placed, state)

    {:ok, state}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  defp calculate_position() do
    Mo.Game.fetch_free_positions()
    |> Enum.random()
  end
end
