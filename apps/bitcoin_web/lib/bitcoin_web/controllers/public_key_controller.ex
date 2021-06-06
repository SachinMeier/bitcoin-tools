defmodule BitcoinWeb.PublicKeyController do
  use BitcoinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", options: BitcoinWeb.PublicKeyView.get_public_key_options(), option: BitcoinWeb.PageView.get_option("public-key"))
  end

  # Parse
  def display(conn, %{"public_key" => pubkey, "option" => option}) do
    pubkey = String.trim(pubkey)
    if pubkey == "" do
      conn
      |> put_flash(:info, "x and y cannot be blank")
      |> render("new.html", option: BitcoinWeb.PublicKeyView.get_option(option))
    else
      case Bitcoin.PublicKey.parse_public_key(pubkey) do
        {:ok, pubkey} -> render(conn, "display_public_key.html", public_key: pubkey, option: BitcoinWeb.PublicKeyView.get_option(option))
        {:error, item} ->
          conn
          |> put_flash(:error, item)
          |> render("new.html", option: BitcoinWeb.PublicKeyView.get_option(option))
      end
    end
  end
  # Serialize
  def display(conn, %{"x" => x, "y" => y, "option" => option}) do
    check_not_null(%{x: x, y: y, option: option},
      fn m -> display_serialize(conn, m) end,
      fn -> 
        conn
        |> put_flash(:info, "x and y cannot be blank")
        |> render("new.html", option: BitcoinWeb.PublicKeyView.get_option(option)) end
    )
  end

  def display(conn, _params) do
		redirect(conn, to: Routes.public_key_path(conn, :index))
	end

  defp display_serialize(conn, m) do
    case Bitcoin.PublicKey.serialize_public_key(m.x,m.y) do
      {:ok, pubkey} -> render(conn, "display_public_key.html", public_key: pubkey, option: m.option)
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> render("new.html", option: BitcoinWeb.PublicKeyView.get_option(m.option))
    end
  end

  def new(conn, %{"option" => option}) do
    render(conn, "new.html", option: BitcoinWeb.PublicKeyView.get_option(option))
  end

  defp check_not_null(map, sc, fc) do
    # Trim all strings
    map = Enum.map(map, fn {k, v} -> {k, String.trim(v)} end)
    nnull = fn {_, str} -> str != "" end
    if Enum.all?(map, nnull) do 
      sc.(Map.new(map))
    else
      fc.() 
    end
  end
end