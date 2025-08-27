defmodule GiolotrelloClientWeb.LoginLive do
  use GiolotrelloClientWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, email: "", password: "", error: nil)}
  end

  @impl true
  def handle_event("login", %{"email" => email, "password" => password}, socket) do
    case Req.post("http://giolotrello-api:4000/api/login",
          json: %{email: email, password: password}
        ) do
      {:ok, %Req.Response{status: 200, body: %{"token" => token}}} ->
        {:noreply,
        socket
        |> put_flash(:info, "Login successful!")
        |> Phoenix.LiveView.put_session(:auth_token, token)
        |> push_navigate(to: ~p"/tasks")}

      {:ok, %Req.Response{status: status, body: body}} ->
        {:noreply, assign(socket, error: "Login failed (#{status}): #{inspect(body)}")}

      {:error, reason} ->
        {:noreply, assign(socket, error: "Error: #{inspect(reason)}")}
    end
  end
end
