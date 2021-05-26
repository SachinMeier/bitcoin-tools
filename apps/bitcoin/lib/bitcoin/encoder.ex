defmodule Bitcoin.Encoder do

	# HASH
	def sha256(preimage) do
		preimage
		|> Bitcoinex.Utils.sha256() 
		|> Base.encode16(case: :lower)
	end

	def ripemd160(preimage) do
		:crypto.hash(:ripemd160, preimage)
		|> Base.encode16(case: :lower)
	end

	def hash160(preimage) do
		preimage
		|> Bitcoinex.Utils.hash160()
		|> Base.encode16(case: :lower)
	end

	# ENCODINGS
	def to_hex(i) when is_integer(i) and i >= 0 do
		{:ok, 
			:binary.encode_unsigned(i)
			|> Base.encode16(case: :lower)
		}
	end
	def to_hex(is) when is_binary(is) do
		try do
			is
			|> String.to_integer()
			|> to_hex()
		rescue 
			_ -> to_hex(:fail)
		end
	end
	def to_hex(e), do: {:error, "data must be a non-negative integer, got: #{e}"}

	def from_hex(s) do
		case Base.decode16(s, case: :lower) do
			{:ok, i} -> {:ok, i |> :binary.decode_unsigned()}
			:error -> {:error, "data must contain only characters 0-9 and a-f"}
		end
	end

	def to_base58(i) do
		nil
	end

	def from_base58(s) do
		nil
	end
end