defmodule BitcoinWeb.SignatureController do
  use BitcoinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", options: BitcoinWeb.SignatureView.get_signature_options())
  end

  def parse(conn, _params) do
    render(conn, "create.html", option: BitcoinWeb.SignatureView.get_option("parse"))
  end

  def new(conn, _params) do
    render(conn, "create.html", option: BitcoinWeb.SignatureView.get_option("new"))
  end

  def verify(conn, _params) do
    render(conn, "create.html", option: BitcoinWeb.SignatureView.get_option("verify"))
  end

  # VERIFY
  def display(conn, %{"signature"=> signature, "public_key" => public_key, "message" => message}) do
    check_not_null(%{signature: signature, 
                      public_key: public_key,
                      message: message},
      fn m -> display_verify(conn, m) end,
      fn -> conn
            |> put_flash(:error, "fields cannot be blank")   
            |> verify(%{}) end
    )
  end

  defp display_verify(conn, m) do
    {:ok, pubkey} = Bitcoin.PublicKey.parse_public_key(m.public_key)
    z =
      m.message
      |> Bitcoinex.Utils.double_sha256()
      |> :binary.decode_unsigned()
    case Bitcoin.Signature.parse_signature(m.signature) do
      {:ok, sig} -> 
        if Bitcoin.Signature.verify_signature(pubkey, z, sig) do
          conn
          |> put_flash(:info, "valid signature")
          |> render("display_signature.html", signature: sig, message: m.message, z: z, public_key: pubkey, option: :verify)
        else
          conn
          |> put_flash(:error, "invalid signature/public key pair")
          |> render("create.html", option: BitcoinWeb.SignatureView.get_option("verify"))
        end
      {:error, msg} ->
        conn
        |> put_flash(:error, msg <> ". Make sure to remove sighash flags from Bitcoin signatures.")
        |> render("create.html", option: BitcoinWeb.SignatureView.get_option("verify"))
    end
  end



  # PARSE
  def display(conn, %{"signature" => signature}) do
    check_not_null(%{signature: signature},
      fn m -> display_parse(conn, m) end,
      fn ->
        conn
        |> put_flash(:info, "signature cannot be blank")
        |> parse(%{}) end
    )
  end

  defp display_parse(conn, m) do
    IO.puts(m.signature)
    case Bitcoin.Signature.parse_signature(m.signature) do
      {:ok, sig} -> render(conn, "display_signature.html", signature: sig, option: :parse)
      {:error, "invalid signature length"} ->
        conn
        |> put_flash(:error, "Invalid signature length. Make sure to remove sighash flags from Bitcoin signatures.")
        |> parse(%{})
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> parse(%{})
    end
  end

  # CREATE
  def display(conn, %{"private_key" => private_key, "message" => message}) do
    check_not_null(%{private_key: private_key, message: message},
      fn m -> display_new(conn, m) end, 
      fn -> conn
            |> put_flash(:error, "do not leave private key or message blank")
            |> new(%{}) end
    )
    
  end

  defp display_new(conn, m) do
    case Bitcoin.PrivateKey.parse_private_key(m.private_key) do
      {:error, _msg} ->
        conn
          |> put_flash(:error, "invalid private key.")
          |> new(%{})
      {:ok, prvkey, _network, _compressed} ->
        z =
          m.message
          |> Bitcoinex.Utils.double_sha256()
          |> :binary.decode_unsigned()
        sig = Bitcoin.PrivateKey.sign_message_hash(prvkey, z)
        pubkey = Bitcoin.PrivateKey.to_public_key(prvkey)
        if Bitcoin.Signature.verify_signature(pubkey, z, sig) do
          render(conn, "display_signature.html", signature: sig, message: m.message, z: z, public_key: pubkey, option: :new)
        else
          conn
            |> put_flash(:error, "signing failed.")
            |> render("new.html")
        end
    end
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
