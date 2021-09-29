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
    Mo.Game.notify(:place_hero, state)

    {:ok, state}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:kill_player, _from, player_state) do
    new_state = Map.put(player_state, :status, :dead)
    Mo.Game.notify(:update_hero, new_state)

    {:reply, new_state, new_state}
  end

  def handle_call({:move, "attack"}, _from, %State{status: :alive} = player_state) do
    Mo.Game.attack_hero_vicinity(player_state)

    {:reply, player_state, player_state}
  end

  def handle_call({:move, direction}, _from, %State{status: :alive} = player_state) do
    if Mo.Game.valid_move?(player_state, direction) do
      new_player_state = move_player(player_state, direction)

      Mo.Game.notify(:remove_hero, player_state)
      Mo.Game.notify(:place_hero, new_player_state)

      {:reply, new_player_state.position, new_player_state}
    else
      {:reply, player_state, player_state}
    end
  end

  def handle_call(:revive, _from, state) do
    Process.send_after(self(), :revive, 5000)

    {:reply, state, state}
  end

  def handle_call(_, _from, state), do: {:reply, state, state}

  def handle_info(:revive, state) do
    new_state = %State{name: state.name, position: calculate_position(), status: :alive}
    Mo.Game.notify(:remove_hero, state)
    Mo.Game.notify(:place_hero, new_state)

    {:noreply, new_state}
  end

  def handle_info(_, state), do: {:noreply, state}

  defp calculate_position() do
    Mo.Game.fetch_free_positions()
    |> Enum.random()
  end

  defp move_player(%State{position: position} = state, "up"), do: Map.put(state, :position, position - 9)
  defp move_player(%State{position: position} = state, "down"), do: Map.put(state, :position, position + 9)
  defp move_player(%State{position: position} = state, "left"), do: Map.put(state, :position, position - 1)
  defp move_player(%State{position: position} = state, "right"), do: Map.put(state, :position, position + 1)

  def move(player_name, direction) do
    GenServer.call({:via, Registry, {Mo.PlayerRegistry, player_name}}, {:move, direction})
  end

  def kill(player) do
    GenServer.call({:via, Registry, {Mo.PlayerRegistry, player.name}}, :kill_player)
    GenServer.call({:via, Registry, {Mo.PlayerRegistry, player.name}}, :revive)
  end
end
