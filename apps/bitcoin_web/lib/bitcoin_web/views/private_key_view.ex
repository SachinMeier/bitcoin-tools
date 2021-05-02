defmodule BitcoinWeb.PrivateKeyView do
  use BitcoinWeb, :view

  @opts [
    %{name: :parse, title: "Parse Private Key", description: "Parse a Private Key from WIF, hex, or integer format."},
    %{name: :sign_message, title: "Sign Message", description: "Use a private key to create an ECDSA signature of a message."},
  ]

  def get_private_key_options, do: @opts

  def get_option(name_str) do
    Enum.find(@opts, &(&1.name == name_str))
  end
end
