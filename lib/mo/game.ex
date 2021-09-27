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

  def handle_cast({:hero_placed, hero_state}, state) do
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

    {:noreply, new_state}
  end

  def fetch_free_positions() do
    GenServer.call(__MODULE__, :free_positions)
  end

  def current_positions() do
    GenServer.call(__MODULE__, :current_positions)
  end

  def notify(:hero_placed, hero_state) do
    GenServer.cast(__MODULE__, {:hero_placed, hero_state})
  end
end
