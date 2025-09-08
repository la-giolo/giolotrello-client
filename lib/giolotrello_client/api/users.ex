defmodule GiolotrelloClient.API.Users do
  alias GiolotrelloClient.API.Client
  alias GiolotrelloClient.Helpers.ApiHelper

  def get_users(token) do
    headers = ApiHelper.bearer(token)

    Client.get("/users", headers: headers)
  end

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
