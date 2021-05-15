defmodule Bitcoin.Stats do
	alias Bitcoin.RawAPI

	#@cmc_api_key "916495be-1bfe-4d18-aadf-63b686c87de5"

	def get_clark_moody_data() do
		url = "https://bitcoin.clarkmoody.com/dashboard/api/state"
		case RawAPI.get(url) do
			{:error, _body} -> {:error, "api call failed"}
			{_status, result} -> result
		end
	end

end

#Bitcoin.Stats.get_clark_moody_data()