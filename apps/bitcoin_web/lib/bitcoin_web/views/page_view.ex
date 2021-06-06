defmodule BitcoinWeb.PageView do
  use BitcoinWeb, :view

  @opts [
    %{name: "public-key", route: &Routes.public_key_path/2, title: "Public Key", description: "Parse, serialize, and generate public keys."},
    %{name: "private-key", route: &Routes.private_key_path/2, title: "Private Key", description: "Parse, serialize, and sign messages with private keys."},
    %{name: "signature", route: &Routes.signature_path/2, title: "Signature", description: "Parse, serialize, and verify ECDSA signatures."},
    %{name: "transaction", route: &Routes.transaction_path/2, title: "Transactions", description: "Parse, craft, and sign Bitcoin transactions."},
    %{name: "encoder", route: &Routes.encoder_path/2, title: "Encoder", description: "Make use of the many encoding schemes and hash functions used by Bitcoin."},
    %{name: "extended-key", route: &Routes.extended_key_path/2, title: "Extended Key (BIP 32)", description: "Parse BIP32 extended keys and derive their children."},
  ]

  def all_items, do: @opts

  def get_option(name_str) do
    Enum.find(@opts, &(&1.name == name_str))
  end

end
