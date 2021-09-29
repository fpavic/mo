defmodule Mo.Game do
  use GenServer

  defmodule State do
    defstruct fields: [
      :wall, :wall, :wall, :wall, :wall, :wall, :wall, :wall, :wall,
      :wall, [], [], [], [], [], [], [], :wall,
      :wall, :wall, [], [], [], :wall, :wall, [], :wall,
      :wall, [], [], [], [], [], :wall, [], :wall,
      :wall, [], :wall, [], [], [], :wall, [], :wall,
      :wall, [], :wall, [], [], [], :wall, [], :wall,
      :wall, [], :wall, [], :wall, :wall, :wall, [], :wall,
      :wall, [], [], [], [], [], [], [], :wall,
      :wall, :wall, :wall, :wall, :wall, :wall, :wall, :wall, :wall
    ]
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    {:ok, %State{}}
  end

  def handle_call(:free_positions, _from, state) do
    positions =
      state.fields
      |> Enum.with_index()
      |> Enum.filter(fn {pos, _index} -> pos == [] end)
      |> Enum.map(fn {_pos, i} -> i end)

    {:reply, positions, state}
  end

  def handle_call(:current_positions, _from, state) do
    {:reply, state.fields, state}
  end

  def handle_call({:valid_move?, player, direction}, _from, state) do
    new_position = calculate_new_position(player.position, direction)

    if Enum.at(state.fields, new_position) != :wall do
      {:reply, true, state}
    else
      {:reply, false, state}
    end
  end

  def handle_call({:place_hero, hero_state}, _from, state) do
    wanted_field = state.fields |> Enum.at(hero_state.position)

    new_state =
      if wanted_field != :wall do
        updated_field = [hero_state | wanted_field]

        fields =
          state.fields
          |> List.replace_at(hero_state.position, updated_field)

        %State{fields: fields}
      else
        state
      end

    {:reply, new_state, new_state}
  end

  def handle_call({:remove_hero, hero_state}, _from, state) do
    field = Enum.at(state.fields, hero_state.position)
    updated_field = Enum.filter(field, & &1.name != hero_state.name)
    new_fields_state = List.replace_at(state.fields, hero_state.position, updated_field)
    new_state = %State{fields: new_fields_state}

    {:reply, new_state, new_state}
  end

  def handle_call({:update_hero, hero_state}, _from, state) do
    field = Enum.at(state.fields, hero_state.position)
    list = List.delete(field, hero_state)
    updated_field = [hero_state | list]

    new_fields_state = List.replace_at(state.fields, hero_state.position, updated_field)
    new_state = %State{fields: new_fields_state}

    {:reply, new_state, new_state}
  end

  def fetch_free_positions() do
    GenServer.call(__MODULE__, :free_positions)
  end

  def current_positions() do
    GenServer.call(__MODULE__, :current_positions)
  end

  def valid_move?(player, direction) do
    GenServer.call(__MODULE__, {:valid_move?, player, direction})
  end

  def notify(:place_hero, hero_state) do
    GenServer.call(__MODULE__, {:place_hero, hero_state})
  end

  def notify(:remove_hero, hero_state) do
    GenServer.call(__MODULE__, {:remove_hero, hero_state})
  end

  def notify(:update_hero, hero_state) do
    GenServer.call(__MODULE__, {:update_hero, hero_state})
  end

  def attack_hero_vicinity(hero_state) do
    positions = current_positions()

    positions
    |> heroes_in_vicinity(hero_state.position)
    |> Enum.each(&Mo.Player.kill(&1))

    positions
    |> heroes_on_current_field(hero_state)
    |> Enum.each(&Mo.Player.kill(&1))
  end

  defp calculate_new_position(position, "up"), do: position - 9
  defp calculate_new_position(position, "down"), do: position + 9
  defp calculate_new_position(position, "left"), do: position - 1
  defp calculate_new_position(position, "right"), do: position + 1

  defp heroes_in_vicinity(fields, position) do
    [position - 10, position - 9, position - 8, position - 1, position + 1, position + 8, position + 9, position + 10]
    |> Enum.map(&Enum.at(fields, &1))
    |> Enum.filter(&(&1 != :wall))
    |> Enum.concat()
  end

  defp heroes_on_current_field(fields, hero) do
    fields
    |> Enum.at(hero.position)
    |> Enum.filter(& &1.name != hero.name)
  end
end
