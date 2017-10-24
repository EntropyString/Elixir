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

alias EntropyString.CharSet

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
defmodule Base64Id, do: use EntropyString, charset: CharSet.charset64

IO.puts "Base64Id: Predefined URL and file system safe CharSet"
IO.puts "  Characters: #{Base64Id.charset}"
IO.puts "  Session ID: #{Base64Id.session_id}\n"

#--------------------------------------------------------------------------------------------------
# Hex Id
#   Predefined hex characters
#--------------------------------------------------------------------------------------------------
defmodule Hex, do: use EntropyString, charset: :charset16

IO.puts "Hex: Predefined hex CharSet"
IO.puts "  Characters: #{Hex.charset}"
IO.puts "  Small ID: #{Hex.small_id}\n"

#--------------------------------------------------------------------------------------------------
# Uppercase Hex Id
#   Uppercase hex characters
#--------------------------------------------------------------------------------------------------
defmodule UpperHex, do: use EntropyString, charset: "0123456789ABCDEF"

IO.puts "UpperHex: Upper case hex CharSet"
IO.puts "  Characters: #{UpperHex.charset}"
IO.puts "  Medium ID: #{UpperHex.medium_id}\n"

#--------------------------------------------------------------------------------------------------
# DingoSky
#   A million potential strings with a 1 in a billion chance of repeat
#--------------------------------------------------------------------------------------------------
defmodule DingoSky do
  use EntropyString, charset: "dingosky"

  @bits entropy_bits(1.0e6, 1.0e9)

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
  use EntropyString, charset: CharSet.charset64

  @bits 256

  def token, do: MyServer.random_string(@bits)
end  

IO.puts "MyServer: 256 entropy bit token"
IO.puts "  Characters: #{MyServer.charset}"
IO.puts "  MyServer Token: #{MyServer.token}\n"
