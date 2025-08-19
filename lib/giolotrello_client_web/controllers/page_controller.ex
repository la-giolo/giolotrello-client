defmodule GiolotrelloClientWeb.PageController do
  use GiolotrelloClientWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
