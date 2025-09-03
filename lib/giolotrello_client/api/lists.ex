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
end
