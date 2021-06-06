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

	def to_base58(str), do: int_to_base58(str)
	
	def int_to_base58(str) do
		try do
			{:ok, 
				# NOT WORKING (leading zeroes)
				str
				|> String.to_integer()
				|> :binary.encode_unsigned()
				|> Bitcoinex.Base58.encode()
			}
		rescue 
			# if not int, try hex
			_ -> hex_to_base58(str)
		end
	end

	def hex_to_base58(str) do
		try do
			{:ok, 
				str
				|> Bitcoin.Util.decode_hex()
				|> Bitcoinex.Base58.encode()
			}
		rescue
			_ -> {:error, "Data must be hex or decimal integer"}
		end
	end

	def from_base58(str) do
		case Bitcoinex.Base58.decode(str) do
			{:ok, bin} -> {:ok, Base.encode16(bin, case: :lower)}
			{:error, msg} -> {:error, "Invalid Base58: #{msg}"}
		end
	end

	def to_base64(str), do: int_to_base64(str)

	def int_to_base64(str) do
		try do
			{:ok,
				str
				|> String.to_integer()
				|> :binary.encode_unsigned()
				|> Base.encode64()
			}
		rescue 
			# if not int, try hex
			_ -> hex_to_base64(str)
		end
	end

	def hex_to_base64(str) do
		try do
			{:ok, 
				str
				|> Bitcoin.Util.decode_hex()
				|> Base.encode64()
			}
		rescue
			_ -> {:error, "Data must be hex or decimal integer"}
		end
	end

	def from_base64(str) do
		case Base.decode64(str) do
			{:ok, bin} -> {:ok, Base.encode16(bin, case: :lower)}
			{:error, msg} -> {:error, "Invalid Base64: #{msg}"}
		end
	end

	# only hex allowed for bech32
	def to_bech32(hrp, str), do: hex_to_bech32(hrp, str)

	def hex_to_bech32(hrp, str) do
		try do
			data = 
				str
				|> Bitcoin.Util.decode_hex()
				|> :binary.bin_to_list()
			
			Bitcoinex.Bech32.encode(hrp, data, :bech32)
		rescue 
			_ -> {:error, "failed to encode"}
		end
	end

	def from_bech32(str) do
		case Bitcoinex.Bech32.decode(str) do
			{:ok, {bech_version, hrp, binlist}} -> 
				{:ok, bech_version, hrp, Base.encode16(:binary.list_to_bin(binlist), case: :lower)}
			{:error, msg} -> {:error, "Invalid Bech32: #{msg}"} 
		end
	end

end