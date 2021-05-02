defmodule BitcoinWeb.SignatureView do
  use BitcoinWeb, :view

  @opts [
    %{name: :parse, title: "Parse Signature", description: "Parse a DER Signature"},
    %{name: :verify, title: "Verify Signature", description: "Verify a signature using a public key and message hash"},
    %{name: :new, title: "Sign Message", description: "Use a private key to create an ECDSA signature of a message."}
  ]

  def get_signature_options, do: @opts

  def get_option(name_str) do
    Enum.find(@opts, &(to_string(&1.name) == name_str))
  end
  # wif: KzhWomzFUcCPHacuWEEiV49zAeQRoPMPe2MXzfLpJY75hCyDrWVQ
  # pubkey: 033b15e1b8c51bb947a134d17addc3eb6abbda551ad02137699636f907ad7e0f1a
  # X: 26725119729089203965150132282997341343516273140835737223575952640907021258522
  # Y: 35176335436138229778595179837068778482032382451813967420917290469529927283651
  # sig: 3044022071223e8822fafbc0b09336d3f2a92fd7970a354d40185d69a297e0500e6c91e602202697b97c52da81a9328fd65a0ad883545f162cc3e5e2c70ea226c0d1cd4ae392
  # msg: hello world
end
