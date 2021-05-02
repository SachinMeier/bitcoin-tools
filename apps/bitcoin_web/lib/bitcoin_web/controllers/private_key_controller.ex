defmodule BitcoinWeb.PrivateKeyController do
  use BitcoinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", options: BitcoinWeb.PrivateKeyView.get_private_key_options())
  end
  # Parse
  def display(conn, %{"private_key" => prvkey}) do
    case Bitcoin.PrivateKey.parse_private_key(prvkey) do
      {:ok, prv, network, compressed} -> render(conn, "display_private_key.html", private_key: prv, network: network, compressed: compressed)
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> render("parse.html")
    end
  end

  def parse(conn, _params) do
    render(conn, "parse.html")
  end

  def create(conn, %{"private_key" => prvkey}) do
    redirect(conn, to: Routes.private_key_path(conn, :display, private_key: String.trim(prvkey)))
  end

  def sign_message(conn, _params), do: redirect(conn, to: Routes.signature_path(conn, :new))

end
