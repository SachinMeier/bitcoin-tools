defmodule Bitcoin.RawAPI do
	alias HTTPoison

	def get(url, headers \\ []) do
		url 
		|> call(:get, headers)
		|> content_type()
		|> decode()
	end

	def call(url, _method, _body \\ "", _query_params \\ %{}, headers\\ []) do
		url
		|> HTTPoison.get(headers)
		|> case do
				{:ok, %{body: raw_body, status_code: code, headers: headers}} -> 
					{code, raw_body, headers}
				{:error, %{reason: reason}} -> 
					{:error, reason, []}
			end
	end

	def content_type({ok, body, headers}) do
		{ok, body, content_type(headers)}
	end
	# find content-type in headers
	def content_type([]), do: "application/json"
	def content_type([{"Content-Type", val} | _]) do
		val 
		|> String.split(";") 
		|> List.first
	end
	def content_type([_ | t]), do: content_type(t)

	# decode JSON
	def decode({ok, body, "application/json"}) do
		body
		|> Poison.decode(keys: :atoms)
		|> case do
				{:ok, parsed} -> {ok, parsed}
				_ -> {:error, body}
			end
	end

	# decode XML
	def decode({ok, body, "application/xml"}) do
		try do
			{ok, body |> :binary.bin_to_list |> :xmerl_scan.string}
		catch
			:exit, _e -> {:error, body}
		end
	end

	# fallback
	def decode({ok, body, _}), do: {ok, body}

end