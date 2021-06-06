defmodule BitcoinWeb.ExtendedKeyController do
  use BitcoinWeb, :controller

	alias Bitcoin.ExtendedKey, as: Xkey

	def index(conn, _params) do
    render(conn, "index.html", 
          options: BitcoinWeb.ExtendedKeyView.get_all_options())
  end

	def seed_to_xprv(conn, _params) do
		render(conn, "derive.html")
	end

	def derive(conn, _params) do
		render(conn, "derive.html")
	end

	def parse(conn, _params) do
		render(conn, "parse.html")
	end

	def convert(conn, _params) do
		render(conn, "convert.html")
	end

	# for derive_key
	def display(conn, %{"extended_key" => parent_key, "deriv_path" => deriv_path_str}) do
		try do
			{:ok, parent_key} = Xkey.parse_extended_key(String.trim(parent_key))
			{:ok, deriv_path} = Xkey.parse_deriv_path(String.trim(deriv_path_str))
			{:ok, child_key} = Xkey.derive_extended_key(parent_key, deriv_path)
			render(conn, "display_derived.html", 
				conn: conn, 
				option: BitcoinWeb.ExtendedKeyView.get_option(:derive),
				parent_key: parent_key, 
				child_key: child_key, 
				deriv_path: deriv_path_str)
		rescue
			_ -> 
				conn
				|> put_flash(:error, "Error: invalid key or derivation path")
				|> render("derive.html", conn: conn, deriv_path: nil)
		end
		
	end

	# For Convert
	def display(conn, %{"convert" => "true", "extended_key" => xkey}) do
		case Xkey.parse_extended_key(String.trim(xkey)) do
			{:ok, xprv} -> 
				case Bitcoin.ExtendedKey.convert_to_xpub(xprv) do
					{:ok, xpub} -> 
						render(conn, "display_converted.html", 
							conn: conn, 
							option: BitcoinWeb.ExtendedKeyView.get_option(:convert),
							xprv: xprv, 
							xpub: xpub)
					{:xpub, _} -> 
						conn
						|> put_flash(:error, "extended key is already xpub. Enter an xprv.")
						|> render("convert.html", conn: conn)
					{:error, msg} -> 
						conn
						|> put_flash(:error, "invalid extended key: #{msg}")
						|> render("convert.html", conn: conn)
				end
			{:error, msg} -> 
				conn
				|> put_flash(:error, "invalid extended key: #{msg}")
				|> render("convert.html", conn: conn)
		end
	end

	# for parse
	def display(conn, %{"extended_key" => xkey}) do
		case Xkey.parse_extended_key(String.trim(xkey)) do
			{:ok, xkey} -> 
				render(conn, "display_parsed.html", 
					conn: conn, 
					option: BitcoinWeb.ExtendedKeyView.get_option(:parse),
					xkey: xkey)
			{:error, msg} -> 
				conn
				|> put_flash(:error, "invalid extended key: #{msg}")
				|> render("parse.html", conn: conn)
		end
	end

	def display(conn, _params) do
		redirect(conn, to: Routes.extended_key_path(conn, :index))
	end
end