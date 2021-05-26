defmodule Bitcoin.Transaction do
  alias Bitcoinex.Transaction

	def full_parse_transaction(tx_hex) do
		try do
			{:ok, txn} = parse_transaction(tx_hex)
			{:ok, split_hex} = split_transaction_hex(tx_hex)
			{:ok, txn, split_hex, tx_hex}
		rescue 
			_ -> {:error, "failed to parse transaction. Note: Segwit currently not supported."}
		end
	end


	def parse_transaction(tx_hex) do
		{:ok, txn} = Transaction.decode(tx_hex)
		split_transaction(txn)
	end

	def split_transaction(txn) do
		tx_id = Transaction.transaction_id(txn)
		version = txn.version
		
		tx_in_count = length(txn.inputs)
    tx_in_count_varint = Transaction.Utils.serialize_compact_size_unsigned_int(tx_in_count)
		
		tx_out_count = length(txn.outputs)
    tx_out_count_varint = Transaction.Utils.serialize_compact_size_unsigned_int(tx_out_count)
    
		lock_time = txn.lock_time |> :binary.encode_unsigned()

		{:ok, %{
			tx_id: tx_id,
			version: version,
		 	
			in_count_varint: tx_in_count_varint |> Base.encode16(case: :lower),
			in_count_int: tx_in_count,
			inputs: txn.inputs,
		 	
			out_count_varint: tx_out_count_varint |> Base.encode16(case: :lower),
			out_count_int: tx_out_count,
			outputs: txn.outputs,

		 	lock_time: lock_time
		}}
	end

	def split_inputs([]), do: []
	def split_inputs([input | rest]) do
		[Transaction.In.serialize_inputs([input]) |> Base.encode16(case: :lower) | split_inputs(rest)]
	end

	def split_outputs([]), do: []
	def split_outputs([output | rest]) do
		[Transaction.Out.serialize_outputs([output]) | split_outputs(rest)]
	end

	#INPUTS
	def split_hex_inputs(counter, inputs) do
    r_split_hex_inputs(inputs, [], counter)
  end

	defp r_split_hex_inputs(remaining, inputs, 0), do: {Enum.reverse(inputs), remaining}

	defp r_split_hex_inputs(
         <<prev_txid::binary-size(32), prev_vout::binary-size(4), remaining::binary>>,
         inputs,
         count
       ) do
		
    {script_len, remaining} = Transaction.Utils.get_counter(remaining)

    <<script_sig::binary-size(script_len), sequence_no::binary-size(4), remaining::binary>> =
      remaining

    input = %{
      prev_txid:
        Base.encode16(prev_txid, case: :lower),
      prev_vout: Base.encode16(prev_vout, case: :lower),
			script_sig_len: Base.encode16(Transaction.Utils.serialize_compact_size_unsigned_int(script_len), case: :lower),
      script_sig: Base.encode16(script_sig, case: :lower),
      sequence_no: Base.encode16(sequence_no, case: :lower)
    }

    r_split_hex_inputs(remaining, [input | inputs], count - 1)
  end

	#OUTPUTS
	def split_hex_outputs(counter, outputs) do
    r_split_hex_outputs(outputs, [], counter)
  end

	defp r_split_hex_outputs(remaining, outputs, 0), do: {Enum.reverse(outputs), remaining}

  defp r_split_hex_outputs(<<value::binary-size(8), remaining::binary>>, outputs, count) do
    {script_len, remaining} = Transaction.Utils.get_counter(remaining)

    <<script_pub_key::binary-size(script_len), remaining::binary>> = remaining

    output = %{
      value: Base.encode16(value, case: :lower),
			script_len: Base.encode16(Transaction.Utils.serialize_compact_size_unsigned_int(script_len), case: :lower),
      script_pub_key: Base.encode16(script_pub_key, case: :lower)
    }

    r_split_hex_outputs(remaining, [output | outputs], count - 1)
  end

	def split_hex(txn) do
		<<version::binary-size(4), remaining::binary>> = txn

		{is_segwit, remaining} =
      case remaining do
        <<1::size(16), segwit_remaining::binary>> ->
					raise "segwit unsupported."
          # {:segwit, segwit_remaining}

        _ ->
          {:not_segwit, remaining}
      end
		
			{in_counter, remaining} = Transaction.Utils.get_counter(remaining)
			{inputs, remaining} = split_hex_inputs(in_counter, remaining)

			{out_counter, remaining} = Transaction.Utils.get_counter(remaining)
			# split outs
			{outputs, remaining} = split_hex_outputs(out_counter, remaining)

			# If flag 0001 is present, this indicates an attached segregated witness structure.
			{witnesses, remaining} =
      	if is_segwit == :segwit do
      	  Transaction.Witness.parse_witness(in_counter, remaining)
      	else
      	  {nil, remaining}
      	end

			<<lock_time::binary-size(4), remaining::binary>> = remaining

			if byte_size(remaining) != 0 do
				:error
			else
				{:ok,
				 %{
					 version: Base.encode16(version, case: :lower),
					 in_count: Base.encode16(:binary.encode_unsigned(in_counter), case: :lower),
					 inputs: inputs,
					 out_count: Base.encode16(:binary.encode_unsigned(out_counter), case: :lower),
					 outputs: outputs,
					 witnesses: witnesses,
					 lock_time: Base.encode16(lock_time, case: :lower),
				 }}
			end
	end

	######## SPLIT HEX #######
	def split_transaction_hex(txn), do: split_hex(Base.decode16!(txn, case: :lower))

	

end
