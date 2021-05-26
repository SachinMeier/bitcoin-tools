defmodule BitcoinWeb.EncoderController do
  use BitcoinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", 
          options: BitcoinWeb.EncoderView.all_items())
    #           page_title: "Encoding Tools", 
    # page_description: BitcoinWeb.EncoderView.page_description()
  end

  def sha256(conn, %{"data" => data, "hex" => hex}) do
    data = String.trim(data)
    if data != "" do
      case dehexify(data, hex) do
        {:ok, data} -> 
          res = Bitcoin.Encoder.sha256(data)
          render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:sha256), data: data, result: res)
        {:error, _} ->
          conn
          |> put_flash(:error, "data is not proper hex")
          |> render("new.html", option: BitcoinWeb.EncoderView.get_option(:sha256), result: nil)
      end
    else
      render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:sha256), result: nil)
    end
  end
  def sha256(conn, _params) do
    render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:sha256), result: nil)
  end

  def ripemd160(conn, %{"data" => data, "hex" => hex}) do
    data = String.trim(data)
    if data != "" do
      case dehexify(data, hex) do
        {:ok, data} -> 
          res = Bitcoin.Encoder.ripemd160(data)
          render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:ripemd160), data: data, result: res)
        {:error, _} ->
          conn
          |> put_flash(:error, "data is not proper hex")
          |> render("new.html", option: BitcoinWeb.EncoderView.get_option(:ripemd160), result: nil)
      end
    else
      render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:ripemd160), result: nil)
    end
  end
  def ripemd160(conn, _params) do
    render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:ripemd160), result: nil)
  end

  def hash160(conn, %{"data" => data, "hex" => hex}) do
    data = String.trim(data)
    if data != "" do
      case dehexify(data, hex) do
        {:ok, data} -> 
          res = Bitcoin.Encoder.hash160(data)
          render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:hash160), data: data, result: res)
        {:error, _} ->
          conn
          |> put_flash(:error, "data is not proper hex")
          |> render("new.html", option: BitcoinWeb.EncoderView.get_option(:hash160), result: nil)
      end
    else
      render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:hash160), result: nil)
    end
  end
  def hash160(conn, _params) do
    render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:hash160), result: nil)
  end

  def hex(conn, %{"data" => data, "encode" => encode}) do
    data = String.trim(data)
    if data != "" do
      case process_data(data, encode, :hex) do
        {:ok, res} ->
          render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:hex), data: data, result: res)
        {:error, msg} ->
          conn
          |> put_flash(:error, "invalid data: " <> msg)
          |> render( "new.html", option: BitcoinWeb.EncoderView.get_option(:hex), result: nil)
      end
    else
      render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:hex), result: nil)
    end
  end
  def hex(conn, _params) do
    render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:hex), result: nil)
  end

  # def base58(conn, %{"data" => data}) do
  #   render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:base58))
  # end

  # def base64(conn, %{"data" => data}) do
  #   render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:base64))
  # end

  # def bech32(conn, %{"data" => data}) do
  #   render(conn, "new.html", option: BitcoinWeb.EncoderView.get_option(:bech32))
  # end

  defp dehexify(data, "false"), do: {:ok, data}
  defp dehexify(data, "true") do
    data = String.downcase(data)
    case Base.decode16(data, case: :lower) do
      {:ok, new_data} -> {:ok, new_data}
      :error -> {:error, "bad hex"}
    end
  end

  defp process_data(data, encode, scheme) do
    case {scheme, encode} do
      {:hex, "false"} -> Bitcoin.Encoder.to_hex(data)
      {:hex, "true"} -> Bitcoin.Encoder.from_hex(data)

      {:base58, "true"} -> {:error, "unimplemented"}
      {:base58, "false"} -> {:error, "unimplemented"}

      {:base64, "true"} -> {:error, "unimplemented"}
      {:base64, "false"} -> {:error, "unimplemented"}

      {:bech32, "true"} -> {:error, "unimplemented"}
      {:bech32, "false"} -> {:error, "unimplemented"}
      {:bech32m, "true"} -> {:error, "unimplemented"}
      {:bech32m, "false"} -> {:error, "unimplemented"}
    end
  end

end