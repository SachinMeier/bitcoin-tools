defmodule BitcoinWeb.ExtendedKeyView do
  use BitcoinWeb, :view

	@opts [
    %{name: :parse, title: "Parse Extended Key", description: "Parse an Extended Key from Base58."},
    %{name: :derive, title: "Derive Child Key", description: "Derive a child extended key from a parent key and derivation path."},
		#%{name: :seed, title: "Seed to Master Key", description: "Transform a BIP32 Seed into a master extended private key."}
    %{name: :convert, title: "Convert XPRV to XPUB", description: "Convert a BIP32 extended private key (XPRV) to extended public key (XPUB)."}
  ]

  def get_all_options, do: @opts

  def get_option(name_str) do
    Enum.find(@opts, &(&1.name == name_str))
  end

end

#xprv9s21ZrQH143K2aUPGNwZSL1XzvBeRhDvs3jPzyEQ1GUT9BCNXifWWinL3fv3gWKq8of7TCc5scQLyZSxYZtewTckLAKadBEzJTqh5TmrRpm