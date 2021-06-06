defmodule BitcoinWeb.PrivateKeyController do
  use BitcoinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", 
      options: BitcoinWeb.PrivateKeyView.get_private_key_options(), 
      option: BitcoinWeb.PageView.get_option("private-key"))
  end
  # Parse
  def display(conn, %{"private_key" => prvkey}) do
    case Bitcoin.PrivateKey.parse_private_key(String.trim(prvkey)) do
      {:ok, prv, network, _compressed} -> render(conn, "display_private_key.html", private_key: prv, network: network)
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> render("parse.html")
    end
  end

  def display(conn, _params) do
		redirect(conn, to: Routes.private_key_path(conn, :index))
	end
  
  def parse(conn, _params) do
    render(conn, "parse.html")
  end

  # def create(conn, %{"private_key" => prvkey}) do
  #   redirect(conn, to: Routes.private_key_path(conn, :display, private_key: String.trim(prvkey)))
  # end

  def sign_message(conn, _params), do: redirect(conn, to: Routes.signature_path(conn, :new))

end


# HEX: a9db414c28b79b1645ae3c3da8f199d9955f1d92df8a1cdc2f4aff2a1de231a0
# INT: 76828261584514996608806727349877622651960303777207076107181657033321193025952
# WIF: L2utZ3kB1Y7PT8KmcbkSkbDgPaN6TA6zVfnaPo9pXp1iqdFSaW7Q