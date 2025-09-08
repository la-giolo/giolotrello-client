defmodule GiolotrelloClient.API.Lists do
  alias GiolotrelloClient.API.Client
  alias GiolotrelloClient.Helpers.ApiHelper

  def get_all_lists(token) do
    headers = ApiHelper.bearer(token)

    Client.get("/lists", headers: headers)
  end

  def create_list(title, token) do
    headers = ApiHelper.bearer(token)
    body = %{list: %{title: title}}

    Client.post("/lists", body, headers: headers)
  end

  def delete_list(list_id, token) do
    headers = ApiHelper.bearer(token)

    Client.delete("/lists/#{list_id}", headers: headers)
  end

  def add_user_to_list(list_id, user_id, token) do
    headers = ApiHelper.bearer(token)

    body = %{ user_id: user_id }

    Client.post("/lists/#{list_id}/users", body, headers: headers)
  end
end
