defmodule BitcoinWeb.TransactionView do
  use BitcoinWeb, :view

  @opts [
    %{name: :parse_transaction, title: "Parse Transaction", description: "Parse a Transaction from hex"},
    %{name: :parse_psbt, title: "Parse PSBT", description: "Parse a Base64-encoded PSBT"},
  ]

  def get_transaction_options, do: @opts

  def get_option(name_str) do
    Enum.find(@opts, &(to_string(&1.name) == name_str))
  end

end

# 0100000002db4c150e716c8f760764f5e638498bf50f9074e298161d62e1b9096acf015bd1000000006a473044022100d25c0220cf7950945e9084011df2d90812394c141985c973332fe1b4e97a40dd021f09375a4d41cac9fb342d1fd7e0ac2761ab54d04beb0aab290cd3f45a9932a701210236692263287cc6ba148e6921773ae09058eb454be530fb6ed1c15db7526499c2ffffffff63eff1082c7d974d9973b4100f160ee5e26a158c942adacebb1705f215dba9d4000000006a47304402202059d5f7f7cbae6e1f1d3d0b6aed1673f7e9415b55c12a64d63a8c6ae7ade27902201f6865160b769caddf75a7f2ee3885d4b537f8c402b535736a4074b25350572301210312c2452da8a534252a6f44940ffe36e12de863bc512a9a3fb2960bededfaa1d1ffffffff01eaa61b00000000001976a914e5de916399cb9978eeddc00c50352b563f48b81c88ac00000000