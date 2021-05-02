defmodule Bitcoin.Signature do
  alias Bitcoinex.Secp256k1
  alias Bitcoinex.Secp256k1.Signature

  # Signatures
  def verify_signature(pubkey, z, sig) when is_integer(z) do
    Secp256k1.verify_signature(pubkey, z, sig)
  end

  def serialize_der_signature(sig) do
    sig
    |> Signature.der_serialize_signature()
    |> Base.encode16(case: :lower)
  end

  def parse_signature(sig) do
    try do
      # is DER?
      sig
      |> Bitcoin.Util.decode_hex()
      |> Signature.der_parse_signature()
    rescue
      _ -> parse_compact_signature(sig)
    end
  end

  @spec parse_compact_signature(any) ::
          {:error, <<_::136, _::_*40>>} | {:ok, Bitcoinex.Secp256k1.Signature.t()}
  def parse_compact_signature(sig) do
    try do
      # is Compact?
      sig
      |> Bitcoin.Util.decode_hex()
      |> Signature.parse_signature()
    rescue
      _ -> {:error, "invalid signature"}
    end
  end

  @spec get_r_s_hex(atom | %{:r => non_neg_integer, :s => non_neg_integer, optional(any) => any}) ::
          {binary, binary}
  def get_r_s_hex(sig) do
    {
      sig.r |> :binary.encode_unsigned() |> Base.encode16(case: :lower),
      sig.s |> :binary.encode_unsigned() |> Base.encode16(case: :lower)
    }
  end

  def split_signature(sig) do
    bin = Signature.der_serialize_signature(sig)
    prefix = :binary.part(bin,0,1) |> Base.encode16(case: :lower)
    length = :binary.part(bin, 1,1) |> Base.encode16(case: :lower)
    r_key_prefix = :binary.part(bin, 2,1) |> Base.encode16(case: :lower)
    r_key_len = :binary.part(bin, 3,1) |> :binary.decode_unsigned()
    s_key_prefix = :binary.part(bin, 4 + r_key_len, 1) |> Base.encode16(case: :lower)
    s_key_len = :binary.part(bin, 5 + r_key_len,1) |> Base.encode16(case: :lower)
    r_key_len = r_key_len |> Integer.to_string(16) |> String.downcase()
    {r,s} = get_r_s_hex(sig)
    {prefix, length, r_key_prefix, r_key_len, r, s_key_prefix, s_key_len, s}
  end

end
