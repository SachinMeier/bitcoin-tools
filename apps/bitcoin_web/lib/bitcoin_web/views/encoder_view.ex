defmodule BitcoinWeb.EncoderView do
  use BitcoinWeb, :view

  @page_description "Tools to encode and decode data using Bitcoin's encoding schemes."

  @opts [
    %{name: :sha256, form: :hash, title: "SHA-256", description: "Calculate the SHA-256 hash of any data."},
    %{name: :ripemd160, form: :hash, title: "RIPEMD160", description: "Calculate the RIPEMD160 hash of any data."},
    %{name: :hash160, form: :hash, title: "Hash160", description: "Calculate the Hash160 hash of any data."},
    %{name: :hex, form: :encoding, title: "Base16 (Hex)", description: "Encode and decode to and from Base16 (hex)."},
    %{name: :base58, form: :encoding, title: "Base58", description: "Encode and decode to and from Base58."},
    %{name: :base64, form: :encoding, title: "Base64", description: "Encode and decode to and from Base64."},
    %{name: :bech32, form: :bech32, title: "Bech32", description: "Encode and decode to and from Bech32 and Bech32m."},
	]

  def all_items, do: @opts

  def get_option(name_a) do
    Enum.find(@opts, &(&1.name) == name_a)
  end

  def page_description, do: @page_description

end

# BECH32 decoding does not yield witness program directly.
# 000e140f070d1a001912060b0d081504140311021d030c1d03040f1814060e1e16
# bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4