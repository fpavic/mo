defmodule MoWeb.GameController do
  use MoWeb, :controller

  def render_board(conn, _params) do
    positions = [
      :wall, :wall, :wall, :wall, :wall, :wall, :wall, :wall, :wall,
      :wall, :tile, :tile, :tile, :tile, :tile, :tile, :tile, :wall,
      :wall, :wall, :tile, :tile, :tile, :wall, :wall, :tile, :wall,
      :wall, :tile, :tile, :tile, :tile, :tile, :wall, :tile, :wall,
      :wall, :tile, :wall, :tile, :tile, :tile, :wall, :tile, :wall,
      :wall, :tile, :wall, :tile, :tile, :tile, :wall, :tile, :wall,
      :wall, :tile, :wall, :tile, :wall, :wall, :wall, :tile, :wall,
      :wall, :tile, :tile, :tile, :tile, :tile, :tile, :tile, :wall,
      :wall, :wall, :wall, :wall, :wall, :wall, :wall, :wall, :wall
    ]
    render(conn, "show.html", positions: positions)
  end
end
