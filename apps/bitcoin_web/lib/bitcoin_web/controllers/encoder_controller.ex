defmodule BitcoinWeb.Encoder do
  use BitcoinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", items: BitcoinWeb.EncoderView.all_items())
  end


end