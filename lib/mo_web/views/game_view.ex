defmodule MoWeb.GameView do
  use MoWeb, :view

  def make_field([], _name), do: "<div class='field' style='background-color:gray'></div>"
  def make_field(:wall, _name), do: "<div class='field' style='background-color:black'></div>"
  def make_field(players_on_field, current_player_name) do
    current_player = Enum.find(players_on_field, & &1.name == current_player_name)
    player = current_player || Enum.at(players_on_field, 0)

    render_field(current_player, player)
  end

  defp render_field(nil, %Mo.Player.State{status: :alive, name: name}) do
    "<div class='field' style='background-color:blue;'><p>#{name}</p></div>"
  end

  defp render_field(_, %Mo.Player.State{status: :alive, name: name}) do
    "<div class='field' style='background-color:green;'><p>#{name}</p></div>"
  end

  defp render_field(_, %Mo.Player.State{status: :dead, name: name}) do
    "<div class='field' style='background-color:red;'><p>#{name}</p></div>"
  end
end
