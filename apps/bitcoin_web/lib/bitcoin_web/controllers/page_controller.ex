defmodule BitcoinWeb.PageController do
  use BitcoinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", items: BitcoinWeb.PageView.all_items())
  end
end
