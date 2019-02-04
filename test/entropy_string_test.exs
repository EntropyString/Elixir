defmodule EntropyString.Test do
  use ExUnit.Case, async: true

  doctest EntropyString

  alias EntropyString.CharSet, as: CharSet

  import EntropyString

  test "Module total and risk entropy bits" do
    defmodule(TotalRisk, do: use(EntropyString, total: 1.0e9, risk: 1.0e12))
    assert round(TotalRisk.bits()) == 99
    assert String.length(TotalRisk.string()) == 20
    assert String.length(TotalRisk.random()) == 20
  end

  test "Module entropy bits" do
    defmodule(Bits, do: use(EntropyString, bits: 122))
    assert round(Bits.bits()) == 122
    assert String.length(Bits.string()) == String.length(Bits.random())
  end

  test "CharSet.charset64()", do: with_64(CharSet.charset64())
  test ":charset64", do: with_64(:charset64)

  defp with_64(charset) do
    assert random(6, charset, <<0xDD>>) == "3"
    assert random(12, charset, <<0x78, 0xFC>>) == "eP"
    assert random(18, charset, <<0xC5, 0x6F, 0x21>>) == "xW8"
    assert random(24, charset, <<0xC9, 0x68, 0xC7>>) == "yWjH"
    assert random(30, charset, <<0xA5, 0x62, 0x20, 0x87>>) == "pWIgh"
    assert random(36, charset, <<0x39, 0x51, 0xCA, 0xCC, 0x8B>>) == "OVHKzI"
    assert random(42, charset, <<0x83, 0x89, 0x00, 0xC7, 0xF4, 0x02>>) == "g4kAx_Q"
    assert random(48, charset, <<0x51, 0xBC, 0xA8, 0xC7, 0xC9, 0x17>>) == "Ubyox8kX"
    assert random(54, charset, <<0xD2, 0xE3, 0xE9, 0xDA, 0x19, 0x97, 0x52>>) == "0uPp2hmXU"
    assert random(60, charset, <<0xD9, 0x39, 0xC1, 0xAF, 0x1E, 0x2E, 0x69, 0x48>>) == "2TnBrx4uaU"

    assert random(66, charset, <<0x78, 0x3F, 0xFD, 0x93, 0xD1, 0x06, 0x90, 0x4B, 0xD6>>) ==
             "eD_9k9EGkEv"

    assert random(72, charset, <<0x9D, 0x99, 0x4E, 0xA5, 0xD2, 0x3F, 0x8C, 0x86, 0x80>>) ==
             "nZlOpdI_jIaA"
  end

  test "CharSet.charset32()", do: with_32(CharSet.charset32())
  test ":charset32", do: with_32(:charset32)

  defp with_32(charset) do
    assert random(5, charset, <<0xDD>>) == "N"
    assert random(10, charset, <<0x78, 0xFC>>) == "p6"
    assert random(15, charset, <<0x78, 0xFC>>) == "p6R"
    assert random(20, charset, <<0xC5, 0x6F, 0x21>>) == "JFHt"
    assert random(25, charset, <<0xA5, 0x62, 0x20, 0x87>>) == "DFr43"
    assert random(30, charset, <<0xA5, 0x62, 0x20, 0x87>>) == "DFr433"
    assert random(35, charset, <<0x39, 0x51, 0xCA, 0xCC, 0x8B>>) == "b8dPFB7"
    assert random(40, charset, <<0x39, 0x51, 0xCA, 0xCC, 0x8B>>) == "b8dPFB7h"
    assert random(45, charset, <<0x83, 0x89, 0x00, 0xC7, 0xF4, 0x02>>) == "qn7q3rTD2"

    assert random(50, charset, <<0xD2, 0xE3, 0xE9, 0xDA, 0x19, 0x97, 0x52>>) == "MhrRBGqLtQ"

    assert random(55, charset, <<0xD2, 0xE3, 0xE9, 0xDA, 0x19, 0x97, 0x52>>) == "MhrRBGqLtQf"
  end

  test "CharSet.charset16()", do: with_16(CharSet.charset16())
  test ":charset16", do: with_16(:charset16)

  defp with_16(charset) do
    assert random(4, charset, <<0x9D>>) == "9"
    assert random(8, charset, <<0xAE>>) == "ae"
    assert random(12, charset, <<0x01, 0xF2>>) == "01f"
    assert random(16, charset, <<0xC7, 0xC9>>) == "c7c9"
    assert random(20, charset, <<0xC7, 0xC9, 0x00>>) == "c7c90"
  end

  test "CharSet.charset8()", do: with_8(CharSet.charset8())
  test ":charset8", do: with_8(:charset8)

  defp with_8(charset) do
    assert random(3, charset, <<0x5A>>) == "2"
    assert random(6, charset, <<0x5A>>) == "26"
    assert random(9, charset, <<0x21, 0xA4>>) == "103"
    assert random(12, charset, <<0x21, 0xA4>>) == "1032"
    assert random(15, charset, <<0xDA, 0x19>>) == "66414"
    assert random(18, charset, <<0xFD, 0x93, 0xD1>>) == "773117"
    assert random(21, charset, <<0xFD, 0x93, 0xD1>>) == "7731172"
    assert random(24, charset, <<0xFD, 0x93, 0xD1>>) == "77311721"
    assert random(27, charset, <<0xC7, 0xC9, 0x07, 0xC9>>) == "617444076"
    assert random(30, charset, <<0xC7, 0xC9, 0x07, 0xC9>>) == "6174440762"
  end

  test "CharSet.charset4()", do: with_4(CharSet.charset4())
  test ":charset4", do: with_4(:charset4)

  defp with_4(charset) do
    assert random(2, charset, <<0x5A>>) == "T"
    assert random(4, charset, <<0x5A>>) == "TT"
    assert random(6, charset, <<0x93>>) == "CTA"
    assert random(8, charset, <<0x93>>) == "CTAG"
    assert random(10, charset, <<0x20, 0xF1>>) == "ACAAG"
    assert random(12, charset, <<0x20, 0xF1>>) == "ACAAGG"
    assert random(14, charset, <<0x20, 0xF1>>) == "ACAAGGA"
    assert random(16, charset, <<0x20, 0xF1>>) == "ACAAGGAT"
  end

  test "CharSet.charset2()", do: with_2(CharSet.charset2())
  test ":charset2", do: with_2(:charset2)

  defp with_2(charset) do
    assert random(1, charset, <<0x27>>) == "0"
    assert random(2, charset, <<0x27>>) == "00"
    assert random(3, charset, <<0x27>>) == "001"
    assert random(4, charset, <<0x27>>) == "0010"
    assert random(5, charset, <<0x27>>) == "00100"
    assert random(6, charset, <<0x27>>) == "001001"
    assert random(7, charset, <<0x27>>) == "0010011"
    assert random(8, charset, <<0x27>>) == "00100111"
    assert random(9, charset, <<0xE3, 0xE9>>) == "111000111"
    assert random(16, charset, <<0xE3, 0xE9>>) == "1110001111101001"
  end

  test "small" do
    assert byte_size(small()) == 6

    assert byte_size(small(:charset64)) == 5
    assert byte_size(small(:charset32)) == 6
    assert byte_size(small(:charset16)) == 8
    assert byte_size(small(:charset8)) == 10
    assert byte_size(small(:charset4)) == 15
    assert byte_size(small(:charset2)) == 29
  end

  test "medium" do
    assert byte_size(medium()) == 14

    assert byte_size(medium(:charset64)) == 12
    assert byte_size(medium(:charset32)) == 14
    assert byte_size(medium(:charset16)) == 18
    assert byte_size(medium(:charset8)) == 23
    assert byte_size(medium(:charset4)) == 35
    assert byte_size(medium(:charset2)) == 69
  end

  test "large" do
    assert byte_size(large()) == 20

    assert byte_size(large(:charset64)) == 17
    assert byte_size(large(:charset32)) == 20
    assert byte_size(large(:charset16)) == 25
    assert byte_size(large(:charset8)) == 33
    assert byte_size(large(:charset4)) == 50
    assert byte_size(large(:charset2)) == 99
  end

  test "session" do
    assert byte_size(session()) == 26

    assert byte_size(session(:charset64)) == 22
    assert byte_size(session(:charset32)) == 26
    assert byte_size(session(:charset16)) == 32
    assert byte_size(session(:charset8)) == 43
    assert byte_size(session(:charset4)) == 64
    assert byte_size(session(:charset2)) == 128
  end

  test "token" do
    assert byte_size(token()) == 43

    assert byte_size(token(:charset64)) == 43
    assert byte_size(token(:charset32)) == 52
    assert byte_size(token(:charset16)) == 64
    assert byte_size(token(:charset8)) == 86
    assert byte_size(token(:charset4)) == 128
    assert byte_size(token(:charset2)) == 256
  end

  test "invalid byte count" do
    {:error, _} = random(7, :charset64, <<1>>)
    {:error, _} = random(13, :charset64, <<1, 2>>)
    {:error, _} = random(25, :charset64, <<1, 2, 3>>)
    {:error, _} = random(31, :charset64, <<1, 2, 3, 4>>)

    {:error, _} = random(6, :charset32, <<1>>)
    {:error, _} = random(16, :charset32, <<1, 2>>)
    {:error, _} = random(21, :charset32, <<1, 2, 3>>)
    {:error, _} = random(31, :charset32, <<1, 2, 3, 4>>)
    {:error, _} = random(32, :charset32, <<1, 2, 3, 4>>)
    {:error, _} = random(41, :charset32, <<1, 2, 3, 4, 5>>)
    {:error, _} = random(46, :charset32, <<1, 2, 3, 4, 5, 6>>)

    {:error, _} = random(9, :charset16, <<1>>)
    {:error, _} = random(17, :charset16, <<1, 2>>)

    {:error, _} = random(7, :charset8, <<1>>)
    {:error, _} = random(16, :charset8, <<1, 2>>)
    {:error, _} = random(25, :charset8, <<1, 2, 3>>)
    {:error, _} = random(31, :charset8, <<1, 2, 3, 4>>)

    {:error, _} = random(9, :charset4, <<1>>)
    {:error, _} = random(17, :charset4, <<1, 2>>)

    {:error, _} = random(9, :charset2, <<1>>)
    {:error, _} = random(17, :charset2, <<1, 2>>)
  end

  test "custom characters" do
    charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ9876543210_-"
    bytes = <<0x9D, 0x99, 0x4E, 0xA5, 0xD2, 0x3F, 0x8C, 0x86, 0x80>>
    assert random(72, charset, bytes) == "NzLoPDi-JiAa"

    charset = "2346789BDFGHJMNPQRTbdfghjlmnpqrt"
    bytes = <<0xD2, 0xE3, 0xE9, 0xDA, 0x19, 0x97, 0x52>>
    assert random(55, charset, bytes) == "mHRrbgQlTqF"

    charset = "0123456789ABCDEF"
    bytes = <<0xC7, 0xC9, 0x00>>
    assert random(20, charset, bytes) == "C7C90"

    charset = "abcdefgh"
    bytes = <<0xC7, 0xC9, 0x07, 0xC9>>
    assert random(30, charset, bytes) == "gbheeeahgc"

    charset = "atcg"
    bytes = <<0x20, 0xF1>>
    assert random(16, charset, bytes) == "acaaggat"

    charset = "HT"
    bytes = <<0xE3, 0xE9>>
    assert random(16, charset, bytes) == "TTTHHHTTTTTHTHHT"
  end

  test "invalid charset" do
    {:error, _} = random(10, <<"H20">>)
    {:error, _} = random(10, <<"H202">>)
  end
end
