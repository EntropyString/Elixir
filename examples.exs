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

# --------------------------------------------------------------------------------------------------
# Id
#   Predefined base 32 characters
# --------------------------------------------------------------------------------------------------
defmodule(Id, do: use(EntropyString))

IO.puts("Id: Predefined base 32 CharSet")
IO.puts("  Bits:       #{Id.bits()}")
IO.puts("  Characters: #{Id.chars()}")
IO.puts("  Random ID:  #{Id.string()}\n")

# --------------------------------------------------------------------------------------------------
# Hex Id
#   Predefined hex characters
# --------------------------------------------------------------------------------------------------
defmodule(Hex, do: use(EntropyString, charset: :charset16))

IO.puts("Hex: Predefined hex character session id")
IO.puts("  Bits:       #{Id.bits()}")
IO.puts("  Characters: #{Hex.chars()}")
IO.puts("  Random ID:  #{Hex.string()}\n")

# --------------------------------------------------------------------------------------------------
# Base64 Id
#   Predefined URL and file system safe characters
# --------------------------------------------------------------------------------------------------
defmodule(Base64Id, do: use(EntropyString, charset: charset64))

IO.puts("Base64Id: Predefined URL and file system safe characters")
IO.puts("  Bits:       #{Id.bits()}")
IO.puts("  Characters: #{Base64Id.chars()}")
IO.puts("  Session ID: #{Base64Id.session()}\n")

# --------------------------------------------------------------------------------------------------
# Uppercase Hex Id
#   Uppercase hex characters
# --------------------------------------------------------------------------------------------------
defmodule(UpperHex, do: use(EntropyString, bits: 64, charset: "0123456789ABCDEF"))

IO.puts("UpperHex: Upper case hex CharSet")
IO.puts("  Bits:       #{UpperHex.bits()}")
IO.puts("  Characters: #{UpperHex.chars()}")
IO.puts("  Random ID:  #{UpperHex.string()}\n")

# --------------------------------------------------------------------------------------------------
# DingoSky
#   Ten million strings with a 1 in a billion chance of repeat
# --------------------------------------------------------------------------------------------------
defmodule(DingoSky, do: use(EntropyString, charset: "dingosky", total: 1.0e7, risk: 1.0e9))

IO.puts("DingoSky: Custom characters for a million IDs with a 1 in a billion chance of repeat")
IO.puts("  Bits:        #{DingoSky.bits()}")
IO.puts("  Characters:  #{DingoSky.chars()}")
IO.puts("  DingoSky ID: #{DingoSky.string()}\n")

# --------------------------------------------------------------------------------------------------
# Server
#   256 entropy bit token
# --------------------------------------------------------------------------------------------------
defmodule(Server, do: use(EntropyString, charset: charset64))

IO.puts("Server: 256 entropy bit token")
IO.puts("  Characters: #{Server.chars()}")
IO.puts("  Token:      #{Server.token()}\n")
