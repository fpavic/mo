defmodule MoWeb.GameView do
  use MoWeb, :view

  def make_field(:tile), do: "<div class='field' style='background-color:gray'></div>"
  def make_field(:wall), do: "<div class='field' style='background-color:black'></div>"
  def make_field(_) do
    "<div class='field' style='background-color:green;'></div>"
  end
end
