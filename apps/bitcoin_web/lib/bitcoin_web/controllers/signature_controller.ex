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
    {:ok, pubkey} = Bitcoin.PublicKey.parse_public_key(public_key)
    z =
      message
      |> Bitcoinex.Utils.double_sha256()
      |> :binary.decode_unsigned()
    {:ok, sig} = Bitcoin.Signature.parse_signature(signature)
    if Bitcoin.Signature.verify_signature(pubkey, z, sig) do
      conn
      |> put_flash(:error, "valid signature")
      |> render("display_signature.html", signature: sig, message: message, z: z, public_key: pubkey, option: :verify)
    else
      conn
        |> put_flash(:error, "invalid signature/public key pair")
        |> render("create.html", option: BitcoinWeb.SignatureView.get_option("verify"))
    end
  end

  # PARSE
  def display(conn, %{"signature" => signature}) do
    case Bitcoin.Signature.parse_signature(signature) do
      {:ok, sig} -> render(conn, "display_signature.html", signature: sig, option: :parse)
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> render("parse.html")
    end
  end

  # CREATE
  def display(conn, %{"private_key" => private_key, "message" => message}) do
    case Bitcoin.PrivateKey.parse_private_key(private_key) do
      {:error, _msg} ->
        conn
          |> put_flash(:error, "invalid private key.")
          |> render("new.html")
      {:ok, prvkey, _network, _compressed} ->
        z =
          message
          |> Bitcoinex.Utils.double_sha256()
          |> :binary.decode_unsigned()
        sig = Bitcoin.PrivateKey.sign_message_hash(prvkey, z)
        pubkey = Bitcoin.PrivateKey.to_public_key(prvkey)
        if Bitcoin.Signature.verify_signature(pubkey, z, sig) do
          render(conn, "display_signature.html", signature: sig, message: message, z: z, public_key: pubkey, option: :new)
        else
          conn
            |> put_flash(:error, "signing failed.")
            |> render("new.html")
        end
    end

  end

  # VERIFY
  def create(conn, %{"signature" => signature, "public_key" => public_key, "message" => message}) do
    redirect(conn, to: Routes.signature_path(conn, :display, option: "verify", signature: String.trim(signature), public_key: String.trim(public_key), message: String.trim(message)))
  end

  # PARSE
  def create(conn, %{"signature" => signature}) do
    redirect(conn, to: Routes.signature_path(conn, :display, option: "parse", signature: String.trim(signature)))
  end

  # CREATE
  def create(conn, %{"private_key" => private_key, "message" => message}) do
    redirect(conn, to: Routes.signature_path(conn, :display, option: "create", private_key: String.trim(private_key), message: message))
  end








end
