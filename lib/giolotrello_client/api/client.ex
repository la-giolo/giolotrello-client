defmodule GiolotrelloClient.API.Client do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://giolotrello-api:4000/api"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Logger, log_level: :info

  adapter Tesla.Adapter.Finch, name: GiolotrelloClient.Finch
end
