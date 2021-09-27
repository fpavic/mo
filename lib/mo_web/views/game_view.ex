defmodule MoWeb.GameView do
  use MoWeb, :view

  def make_field([], _name), do: "<div class='field' style='background-color:gray'></div>"
  def make_field(:wall, _name), do: "<div class='field' style='background-color:black'></div>"
  def make_field(players_on_field, current_player_name) do
    if Enum.find(players_on_field, & &1.name == current_player_name) do
    "<div class='field' style='background-color:green;'><p>#{current_player_name}</p></div>"
    else
      name = Enum.at(players_on_field, 0).name
      "<div class='field' style='background-color:blue;'><p>#{name}</p></div>"
    end
  end
end
