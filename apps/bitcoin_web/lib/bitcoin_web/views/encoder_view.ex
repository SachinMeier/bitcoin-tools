defmodule BitcoinWeb.EncoderView do
  use BitcoinWeb, :view

  @opts [
    %{name: "hex", route: &Routes.signature_path/2, title: "Base16 (Hex)", description: "Encode and decode to and from Base16 (hex)."},
    %{name: "base58", route: &Routes.signature_path/2, title: "Base58", description: "Encode and decode to and from Base58."},
    %{name: "bech32", route: &Routes.signature_path/2, title: "Bech32", description: "Encode and decode to and from Bech32 and Bech32m."},
	]

  def all_items, do: @opts

end
