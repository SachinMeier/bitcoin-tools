defmodule BitcoinWeb.PublicKeyController do
  use BitcoinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", options: BitcoinWeb.PublicKeyView.get_public_key_options())
  end

  # Parse
  def display(conn, %{"public_key" => pubkey, "option" => option}) do
    case Bitcoin.PublicKey.parse_public_key(pubkey) do
      {:ok, pubkey} -> render(conn, "display_public_key.html", public_key: pubkey, option: option)
      {:error, item} ->
        conn
        |> put_flash(:error, item)
        |> render("new.html", option: BitcoinWeb.PublicKeyView.get_option(option))
    end
  end
  # Serialize
  def display(conn, %{"x" => x, "y" => y, "option" => option}) do
    case Bitcoin.PublicKey.serialize_public_key(x,y) do
      {:ok, pubkey} -> render(conn, "display_public_key.html", public_key: pubkey, option: option)
      {:error, item} ->
        IO.puts "\n\n\nx: #{x}\ny: #{y} \n\n\n\n"
        conn
        |> put_flash(:error, item)
        |> render("new.html", option: BitcoinWeb.PublicKeyView.get_option(option))
    end
  end

  def new(conn, %{"option" => option}) do
    render(conn, "new.html", option: BitcoinWeb.PublicKeyView.get_option(option))
  end

  def create(conn, %{"public_key" => public_key, "option" => option }) do
    redirect(conn, to: Routes.public_key_path(conn, :display, public_key: String.trim(public_key), option: option))
  end

  def create(conn, %{"x" => x, "y" => y, "option" => option}) do
    redirect(conn, to: Routes.public_key_path(conn, :display, x: String.trim(x), y: String.trim(y), option: option))
  end


end

#<button onclick="copyTextToClipboard('<%= Bitcoin.PublicKey.serialize_public_key(@public_key) %>')">copy to clipboard</button>
#<a onclick="copyTextToClipboard('<%= Bitcoin.PublicKey.serialize_public_key(@public_key) %>')">copy to clipboard</a>
