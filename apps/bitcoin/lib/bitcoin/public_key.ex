defmodule Bitcoin.PublicKey do
  alias Bitcoinex.Secp256k1
  alias Bitcoinex.Secp256k1.Point

  def parse_public_key(key) do
    try do
      res =
        key
        |> String.downcase()
        |> Point.parse_public_key()
    rescue
      _ -> {:error, "failed to parse key"}
    end
  end
  def serialize_public_key(key = %Point{}) do
    Point.serialize_public_key(key)
  end

  def serialize_public_key(x,y) when is_integer(x) and is_integer(y) do
    serialize_pubkey_ints(x,y)
  end
  def serialize_public_key(x, y) do
    try do
      x = String.to_integer(x)
      y = String.to_integer(y)
      serialize_pubkey_ints(x,y)
    rescue
      _ ->
        serialize_pubkey_hex(x,y)
    end
  end

  defp serialize_pubkey_hex(x,y) do
    try do
      x = Bitcoin.Util.decode_hex_to_int(x)
      y = Bitcoin.Util.decode_hex_to_int(y)
      serialize_pubkey_ints(x,y)
    rescue
      _ -> {:error, "invalid public key"}
    end
  end

  defp serialize_pubkey_ints(x,y) do
    try do
      {:ok, y1} = Bitcoinex.Secp256k1.get_y(x, rem(y,2) == 1)
      if y1 == y do
        {:ok, %Point{x: x, y: y}}
      else
        {:error, "point is not on secp256k1 curve"}
      end
    rescue
      _ -> {:error, "failed to serialize key"}
    end
    end
  def verify_public_key(key) do
    {:ok, key} = parse_public_key(key)
    Secp256k1.verify_point(key)
  end

  def split_public_key(pubkey) do
    prefix = if rem(pubkey.y,2) == 1, do: "03", else: "02"
    x_hex = Bitcoin.Util.encode_int_to_hex(pubkey.x)
    y_hex = Bitcoin.Util.encode_int_to_hex(pubkey.y)
    {:ok, prefix, x_hex, y_hex}
  end

end
