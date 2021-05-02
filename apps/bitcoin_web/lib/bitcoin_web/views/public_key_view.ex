defmodule BitcoinWeb.PublicKeyView do
  use BitcoinWeb, :view

  @opts [
    %{name: "parse", title: "Parse Public Key", description: "Get the X and Y coordinates of a public key from its compressed or uncompressed SEC format."},
    %{name: "serialize", title: "Serialize Public Key", description: "Serialize a Point with X and Y coordinates into compressed SEC format."}
  ]

  def get_public_key_options, do: @opts

  def get_option(name_str) do
    Enum.find(@opts, &(&1.name == name_str))
  end
end
