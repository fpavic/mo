defmodule MoWeb.PageController do
  use MoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
