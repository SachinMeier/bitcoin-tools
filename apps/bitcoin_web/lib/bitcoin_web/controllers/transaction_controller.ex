defmodule BitcoinWeb.TransactionController do
  use BitcoinWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", options: BitcoinWeb.TransactionView.get_transaction_options())
  end

  def parse(conn, _params) do
    render(conn, "new.html", option: BitcoinWeb.TransactionView.get_option("parse_transaction"))
  end

  # PARSE
  def display(conn, %{"transaction_hex" => transaction_hex}) do
    case Bitcoin.Transaction.parse_transaction(transaction_hex) do
      {:ok, txn} -> render(conn, "display_transaction.html", transaction: txn, option: :parse)
      {:error, msg} ->
        conn
        |> put_flash(:info, msg)
        |> parse(%{})
    end
  end



end
