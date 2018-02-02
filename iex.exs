Application.put_env(:elixir, :ansi_enabled, true)
IEx.configure(
  colors: [enabled: true],
  default_prompt: [
    "\e[G",    # ANSI CHA, move cursor to column 1
    :magenta,
    "ES-%prefix", # IEx prompt variable
    ">",       # plain string
    :reset
  ] |> IO.ANSI.format |> IO.chardata_to_string
)

import_file "./lib/charset.ex"
import_file "./lib/entropy_string.ex"
IO.puts "\nEntropyString Loaded"

IO.puts "\n------------------------"
IO.puts "  Execute examples.exs"
IO.puts "------------------------\n"
import_file "./examples.exs"
