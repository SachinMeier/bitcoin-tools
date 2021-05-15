defmodule BitcoinWeb.StatsController do
  use BitcoinWeb, :controller

	def index(conn, _params) do
		case BitcoinWeb.StatsView.get_test_metrics() do
			{:error, _} -> 
				conn
				|> put_flash(:error, "data could not be loaded, try again later.")
				|> redirect(to: Routes.page_path(conn, :index))
			{:ok, res} ->
				render(conn, "index.html", stats: res)
		end
	end
end
