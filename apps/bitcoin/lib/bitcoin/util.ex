defmodule Bitcoin.Util do

  def decode_hex(str) do
    str
    |> String.downcase()
    |> Base.decode16!(case: :lower)
  end

  def decode_hex_to_int(str) do
    str
    |> String.downcase()
    |> Base.decode16!(case: :lower)
    |> :binary.decode_unsigned()
  end

  def encode_int_to_hex(i) do
    i
    |> :binary.encode_unsigned()
    |> Base.encode16(case: :lower)
  end

  def flip_endianness(hex) do
    Base.decode16!(hex, case: :lower) 
    |> :binary.encode_unsigned(:little) 
    |> Base.encode16(case: :lower)
  end

end
