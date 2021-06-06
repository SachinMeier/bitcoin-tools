defmodule Bitcoin.ExtendedKey do

	def parse_extended_key(xkey_str) do
		Bitcoinex.ExtendedKey.parse_extended_key(xkey_str)
	end

	def parse_deriv_path(deriv_str) do
		Bitcoinex.ExtendedKey.DerivationPath.from_string(deriv_str)
	end

	def serialize_extended_key(xkey) do
		Bitcoinex.ExtendedKey.display_extended_key(xkey)
	end

	def derive_extended_key(parent_key, deriv_path) when is_binary(parent_key) and is_binary(deriv_path) do
		case {parse_extended_key(parent_key), parse_deriv_path(deriv_path)} do
			{{:ok, xkey}, {:ok, deriv_path}} ->
				derive_extended_key(xkey, deriv_path)
			_ -> {:error, "Err: invalid extended key or deriv path"}
		end
	end
	def derive_extended_key(parent_key, deriv_path) do
		Bitcoinex.ExtendedKey.derive_extended_key(parent_key, deriv_path) 
	end

	def get_xkey_data(xkey) do
		{:ok, 
			Bitcoinex.ExtendedKey.network_from_extended_key(xkey) == :testnet,
			Bitcoinex.ExtendedKey.get_prefix(xkey) in [<<0x04, 0x88, 0xAD, 0xE4>>, <<0x04, 0x35, 0x83, 0x94>>]
		}
	end

	def split_extended_key(xkey) do
		%{
			prefix: Base.encode16(xkey.prefix, case: :lower),
			depth: Base.encode16(xkey.depth, case: :lower),
			parent_fingerprint: Base.encode16(xkey.parent_fingerprint, case: :lower),
			child_num: Base.encode16(xkey.child_num, case: :lower),
			chaincode: Base.encode16(xkey.chaincode, case: :lower),
			key: Base.encode16(xkey.key, case: :lower),
			checksum: Base.encode16(xkey.checksum, case: :lower)
		}
	end

	def convert_to_xpub(xprv) do
		case Bitcoinex.ExtendedKey.to_extended_public_key(xprv) do
			{:ok, xpub} -> {:ok, xpub}
			{:error, msg} -> {:error, msg}
			xpub -> {:xpub, xpub}
		end
	end

end