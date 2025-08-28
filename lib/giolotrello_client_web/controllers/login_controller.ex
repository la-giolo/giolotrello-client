defmodule GiolotrelloClientWeb.LoginController do
  use GiolotrelloClientWeb, :controller

  def new(conn, _params) do
    render(conn, :new, layout: false)
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Req.post("http://giolotrello-api:4000/api/login",
           json: %{email: email, password: password}
         ) do
      {:ok, %Req.Response{status: 200, body: %{"token" => token}}} ->
        conn
        |> put_session(:auth_token, token)
        |> put_flash(:info, "Login successful!")
        |> redirect(to: ~p"/home")

      {:ok, %Req.Response{status: status, body: body}} ->
        conn
        |> put_flash(:error, "Login failed (#{status}): #{inspect(body)}")
        |> render(:new, layout: false)

      {:error, reason} ->
        conn
        |> put_flash(:error, "Error: #{inspect(reason)}")
        |> render(:new, layout: false)
    end
  end
end
