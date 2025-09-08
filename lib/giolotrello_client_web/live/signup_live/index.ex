defmodule GiolotrelloClientWeb.SignupLive.Index do
  use GiolotrelloClientWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, errors: %{})}
  end

  @impl true
  def handle_event(
        "signup",
        %{"user" => %{"email" => email, "password" => password, "confirm_password" => confirm}},
        socket
      ) do
    cond do
      password != confirm ->
        {:noreply, assign(socket, errors: %{"confirm_password" => ["Password does not match"]})}

      true ->
        case GiolotrelloClient.API.Users.create_user(%{"email" => email, "password" => password}) do
          {:ok, %Tesla.Env{status: 201}} ->
            {:noreply,
             socket
             |> assign(:errors, %{})
             |> put_flash(:info, "Account created! Please log in.")
             |> push_navigate(to: ~p"/login")}

          {:ok, %Tesla.Env{status: 422, body: %{"errors" => errors}}} ->
            {:noreply, assign(socket, errors: errors)}

          {:ok, %Tesla.Env{status: status, body: body}} ->
            {:noreply,
             socket
             |> assign(:errors, %{})
             |> put_flash(:error, "Sign up failed (#{status}): #{inspect(body)}")}

          {:error, reason} ->
            {:noreply,
             socket
             |> assign(:errors, %{})
             |> put_flash(:error, "Sign up error: #{inspect(reason)}")}
        end
    end
  end
end
