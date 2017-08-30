#
# Compile library before running this example file:
#
#   > mix compile
#
# Launching the Elixir shell from the project base directory load EntropyString and runs
# the examples
#
#   > iex
#

#--------------------------------------------------------------------------------------------------
# Id
#   Predefined base 32 characters
#--------------------------------------------------------------------------------------------------
defmodule Id, do: use EntropyString

IO.puts "Id: Predefined base 32 CharSet"
IO.puts "  Characters: #{Id.charset}"
IO.puts "  Session ID: #{Id.session_id}\n"

#--------------------------------------------------------------------------------------------------
# Base64Id
#   Predefined URL and file system safe characters
#--------------------------------------------------------------------------------------------------
defmodule Base64Id, do: use EntropyString, charset: EntropyString.CharSet.charset64

IO.puts "Base64Id: Predefined URL and file system safe CharSet"
IO.puts "  Characters: #{Base64Id.charset}"
IO.puts "  Session ID: #{Base64Id.session_id}\n"

#--------------------------------------------------------------------------------------------------
# HexId
#   Predefined hex characters
#--------------------------------------------------------------------------------------------------
defmodule HexId, do: use EntropyString, charset: EntropyString.CharSet.charset16

IO.puts "HexId: Predefined hex CharSet"
IO.puts "  Characters: #{HexId.charset}"
IO.puts "  Small ID: #{HexId.small_id}\n"

#--------------------------------------------------------------------------------------------------
# UpperHexId
#   Uppercase hex characters
#--------------------------------------------------------------------------------------------------
defmodule UpperHexId, do: use EntropyString, charset: "0123456789ABCDEF"

IO.puts "UpperHexId: Upper case hex CharSet"
IO.puts "  Characters: #{UpperHexId.charset}"
IO.puts "  Medium ID: #{UpperHexId.medium_id}\n"

#--------------------------------------------------------------------------------------------------
# DingoSky
#   A million potential strings with a 1 in a billion chance of repeat
#--------------------------------------------------------------------------------------------------
defmodule DingoSky do
  use EntropyString, charset: "dingosky"

  @bits entropy_bits(ten_p(6), ten_p(9))

  def id, do: DingoSky.random_string(@bits)
end  

IO.puts "DingoSky: Custom CharSet for a million IDs with a 1 in a billion chance of repeat"
IO.puts "  Characters: #{DingoSky.charset}"
IO.puts "  DingoSky ID: #{DingoSky.id}\n"

#--------------------------------------------------------------------------------------------------
# MyServer
#   256 entropy bit token
#--------------------------------------------------------------------------------------------------
defmodule MyServer do
  use EntropyString, charset: EntropyString.CharSet.charset64

  @bits 256

  def token, do: MyServer.random_string(@bits)
end  

IO.puts "MyServer: 256 entropy bit token"
IO.puts "  Characters: #{MyServer.charset}"
IO.puts "  MyServer Token: #{MyServer.token}\n"


