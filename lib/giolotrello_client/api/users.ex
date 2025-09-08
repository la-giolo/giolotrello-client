defmodule GiolotrelloClient.API.Users do
  alias GiolotrelloClient.API.Client

  def create_user(params) do
    body = %{
      user: %{
        email: params["email"],
        password: params["password"]
      }
    }

    Client.post("/users", body)
  end
end
