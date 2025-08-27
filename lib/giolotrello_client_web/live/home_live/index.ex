defmodule GiolotrelloClientWeb.HomeLive.Index do
  use GiolotrelloClientWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    token = session["auth_token"]

    socket =
      case fetch_lists(token) do
        {:ok, lists} -> assign(socket, :lists, lists)
        {:error, _} -> assign(socket, :lists, [])
      end

    {:ok, socket}
  end

  defp fetch_lists(nil), do: {:error, :no_token}

  defp fetch_lists(token) do
    case Req.get("http://giolotrello-api:4000/api/lists",
           headers: [{"authorization", "Bearer " <> token}]
         ) do
      {:ok, %Req.Response{status: 200, body: %{"lists" => lists}}} ->
        {:ok, lists}

      {:ok, %Req.Response{status: status}} ->
        {:error, status}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
