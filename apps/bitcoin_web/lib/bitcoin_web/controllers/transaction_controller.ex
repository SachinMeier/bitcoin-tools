defmodule BitcoinWeb.TransactionController do
  use BitcoinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", 
      options: BitcoinWeb.TransactionView.get_transaction_options(),
      meta_attrs: [%{name: "title", content: "Bitcoin Transaction Tools"},
                    %{name: "category", content: "transaction"}]
      )
  end

  def parse(conn, _params) do
    render(conn, "new.html", option: BitcoinWeb.TransactionView.get_option("parse_transaction"))
  end

  # PARSE
  def display(conn, %{"transaction_hex" => transaction_hex}) do
    case Bitcoin.Transaction.full_parse_transaction(transaction_hex) do
      {:ok, txn, split_hex, tx_hex} -> 
        render(conn, "display_transaction.html", 
          transaction: txn, 
          split_hex: split_hex, 
          tx_hex: tx_hex, 
          option: :parse,

          title: "Parse Bitcoin Transaction",
          category: "transaction/"
        )
      {:error, msg} ->
        conn
        |> put_flash(:info, msg)
        |> parse(%{})
    end
  end



end
