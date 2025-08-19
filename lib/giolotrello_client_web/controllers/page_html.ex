defmodule GiolotrelloClientWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use GiolotrelloClientWeb, :html

  embed_templates "page_html/*"
end
