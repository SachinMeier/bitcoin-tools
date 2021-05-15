defmodule Bitcoin.Transaction do
  alias Bitcoinex.Transaction


	def parse_transaction(tx_hex) do
		Transaction.decode(tx_hex)
	end

	# def split_transaction(txn) do
	# 	tx_id = Transaction.transaction_id(txn)
	# 	version = <<txn.version::little-size(32)>>
  #   tx_in_count = serialize_compact_size_unsigned_int(length(txn.inputs))
  #   inputs = Transaction.In.serialize_inputs(txn.inputs)
  #   tx_out_count = serialize_compact_size_unsigned_int(length(txn.outputs))
  #   outputs = Transaction.Out.serialize_outputs(txn.outputs)
  #   lock_time = <<txn.lock_time::little-size(32)>>

	# 	{version, tx_in_count, inputs, tx_out_count, outputs, lock_time}
	# end

	# def split_inputs([]), do: []
	# def split_inputs([input | rest]) do
	# 	[Transaction.In.serialize_inputs(input) | split_inputs(rest)]
	# end

	# # copied from bitcoinex
	# defp parse(tx_bytes) do
	# 		<<version::binary-size(4), remaining::binary>> = tx_bytes

	# 		{is_segwit, remaining} =
	# 			case remaining do
	# 				<<1::little-size(2), segwit_remaining::binary>> ->
	# 					{:segwit, segwit_remaining}
	
	# 				_ ->
	# 					{:not_segwit, remaining}
	# 			end

	# 		# Inputs.
	# 		{in_counter, remaining} = Transaction.TxUtils.get_counter(remaining)
	# 		{inputs, remaining} = Transaction.In.parse_inputs(in_counter, remaining)
	
	# 		# Outputs.
	# 		{out_counter, remaining} = TxUtils.get_counter(remaining)
	# 		{outputs, remaining} = Out.parse_outputs(out_counter, remaining)
	
	# 		# If flag 0001 is present, this indicates an attached segregated witness structure.
	# 		{witnesses, remaining} =
	# 			if is_segwit == :segwit do
	# 				Witness.parse_witness(in_counter, remaining)
	# 			else
	# 				{nil, remaining}
	# 			end
	
	# 		<<lock_time::little-size(32), remaining::binary>> = remaining
	
	# 		if byte_size(remaining) != 0 do
	# 			:error
	# 		else
	# 			%{
	# 				 version: version,
	# 				 input_count: in_counter,
	# 				 inputs: inputs,
	# 				 output_count: out_counter,
	# 				 outputs: outputs,
	# 				 witnesses: witnesses,
	# 				 lock_time: lock_time
	# 			 }
	# 		end
	# end

end