defmodule MoWeb.GameController do
  use MoWeb, :controller

  def render_board(conn, params) do
    conn =
      case get_session(conn, :hero_name) do
        nil ->
          name = params["name"] || generate_random_name()
          spawn_player_process(name)
          put_session(conn, :hero_name, name)

        name ->
          spawn_player_process(name)
          conn
      end

    fields = Mo.Game.current_positions()
    name = get_session(conn, :hero_name)
    render(conn, "show.html", fields: fields, current_player_name: name)
  end

  defp spawn_player_process(name) do
    DynamicSupervisor.start_child(Mo.PlayerSupervisor, {Mo.Player, hero_name: name, name: {:via, Registry, {Mo.PlayerRegistry, name}}})
  end

  defp generate_random_name() do
    suffix =
      :crypto.strong_rand_bytes(4)
      |> Base.encode16()

    "HERO #{suffix}"
  end
end
