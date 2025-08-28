defmodule GiolotrelloClientWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller

  use GiolotrelloClientWeb, :verified_routes

  def init(default), do: default

  def call(conn, _opts) do
    if get_session(conn, :auth_token) do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end
end
