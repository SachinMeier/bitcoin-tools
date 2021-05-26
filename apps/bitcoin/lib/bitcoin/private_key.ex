defmodule Bitcoin.PrivateKey do
  alias Bitcoinex.Secp256k1

  # Private Key
  def parse_private_key(prvkey) do
    try do
      # Is WIF?
      case Secp256k1.PrivateKey.parse_wif(prvkey) do
        {:error, _} -> raise ArgumentError
        {:ok, prv, network, true} -> {:ok, prv, network, true}
      end
    rescue
      _ -> parse_int(prvkey)
    end
  end

  defp parse_int(prvkey) do
    try do
      # Is int?
      prv = String.to_integer(prvkey)
      {:ok, %Secp256k1.PrivateKey{d: prv}, :mainnet, true}
    rescue
      _ -> parse_hex(prvkey)
    end
  end

  defp parse_hex(prvkey) do
    try do
      # Is hex?
      prv =
        prvkey
        |> String.downcase()
        |> Base.decode16!(case: :lower)
        |> :binary.decode_unsigned()
      {:ok, %Secp256k1.PrivateKey{d: prv}, :mainnet, true}
    rescue
      _ -> {:error, "invalid private key"}
    end
  end

  

  def to_public_key(prvkey), do: Secp256k1.PrivateKey.to_point(prvkey)

  def serialize_private_key_hex(key), do: Secp256k1.PrivateKey.serialize_private_key(key)
  def serialize_private_key_wif(key, network), do: Secp256k1.PrivateKey.wif!(key, network)

  def sign_message(key, msg) do
    z = Bitcoinex.Utils.double_sha256(msg)
    Secp256k1.PrivateKey.sign(key, z)
  end
  def sign_message_hash(key, z), do: Secp256k1.PrivateKey.sign(key, z)

end
