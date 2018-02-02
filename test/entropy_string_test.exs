defmodule EntropyStringTest do
  use ExUnit.Case, async: true

  doctest EntropyString

  alias EntropyString.CharSet, as: CharSet

  import EntropyString

  test "CharSet 64" do
    charset = CharSet.charset64()
    assert random_string(6, charset, <<0xDD>>) == "3"
    assert random_string(12, charset, <<0x78, 0xFC>>) == "eP"
    assert random_string(18, charset, <<0xC5, 0x6F, 0x21>>) == "xW8"
    assert random_string(24, charset, <<0xC9, 0x68, 0xC7>>) == "yWjH"
    assert random_string(30, charset, <<0xA5, 0x62, 0x20, 0x87>>) == "pWIgh"
    assert random_string(36, charset, <<0x39, 0x51, 0xCA, 0xCC, 0x8B>>) == "OVHKzI"
    assert random_string(42, charset, <<0x83, 0x89, 0x00, 0xC7, 0xF4, 0x02>>) == "g4kAx_Q"
    assert random_string(48, charset, <<0x51, 0xBC, 0xA8, 0xC7, 0xC9, 0x17>>) == "Ubyox8kX"
    assert random_string(54, charset, <<0xD2, 0xE3, 0xE9, 0xDA, 0x19, 0x97, 0x52>>) == "0uPp2hmXU"

    assert random_string(60, charset, <<0xD9, 0x39, 0xC1, 0xAF, 0x1E, 0x2E, 0x69, 0x48>>) ==
             "2TnBrx4uaU"

    assert random_string(66, charset, <<0x78, 0x3F, 0xFD, 0x93, 0xD1, 0x06, 0x90, 0x4B, 0xD6>>) ==
             "eD_9k9EGkEv"

    assert random_string(72, charset, <<0x9D, 0x99, 0x4E, 0xA5, 0xD2, 0x3F, 0x8C, 0x86, 0x80>>) ==
             "nZlOpdI_jIaA"
  end

  test "CharSet 32" do
    charset = CharSet.charset32()
    assert random_string(5, charset, <<0xDD>>) == "N"
    assert random_string(10, charset, <<0x78, 0xFC>>) == "p6"
    assert random_string(15, charset, <<0x78, 0xFC>>) == "p6R"
    assert random_string(20, charset, <<0xC5, 0x6F, 0x21>>) == "JFHt"
    assert random_string(25, charset, <<0xA5, 0x62, 0x20, 0x87>>) == "DFr43"
    assert random_string(30, charset, <<0xA5, 0x62, 0x20, 0x87>>) == "DFr433"
    assert random_string(35, charset, <<0x39, 0x51, 0xCA, 0xCC, 0x8B>>) == "b8dPFB7"
    assert random_string(40, charset, <<0x39, 0x51, 0xCA, 0xCC, 0x8B>>) == "b8dPFB7h"
    assert random_string(45, charset, <<0x83, 0x89, 0x00, 0xC7, 0xF4, 0x02>>) == "qn7q3rTD2"

    assert random_string(50, charset, <<0xD2, 0xE3, 0xE9, 0xDA, 0x19, 0x97, 0x52>>) ==
             "MhrRBGqLtQ"

    assert random_string(55, charset, <<0xD2, 0xE3, 0xE9, 0xDA, 0x19, 0x97, 0x52>>) ==
             "MhrRBGqLtQf"
  end

  test "CharSet 16" do
    charset = CharSet.charset16()
    assert random_string(4, charset, <<0x9D>>) == "9"
    assert random_string(8, charset, <<0xAE>>) == "ae"
    assert random_string(12, charset, <<0x01, 0xF2>>) == "01f"
    assert random_string(16, charset, <<0xC7, 0xC9>>) == "c7c9"
    assert random_string(20, charset, <<0xC7, 0xC9, 0x00>>) == "c7c90"
  end

  test "CharSet 8" do
    charset = CharSet.charset8()
    assert random_string(3, charset, <<0x5A>>) == "2"
    assert random_string(6, charset, <<0x5A>>) == "26"
    assert random_string(9, charset, <<0x21, 0xA4>>) == "103"
    assert random_string(12, charset, <<0x21, 0xA4>>) == "1032"
    assert random_string(15, charset, <<0xDA, 0x19>>) == "66414"
    assert random_string(18, charset, <<0xFD, 0x93, 0xD1>>) == "773117"
    assert random_string(21, charset, <<0xFD, 0x93, 0xD1>>) == "7731172"
    assert random_string(24, charset, <<0xFD, 0x93, 0xD1>>) == "77311721"
    assert random_string(27, charset, <<0xC7, 0xC9, 0x07, 0xC9>>) == "617444076"
    assert random_string(30, charset, <<0xC7, 0xC9, 0x07, 0xC9>>) == "6174440762"
  end

  test "CharSet 4" do
    charset = CharSet.charset4()
    assert random_string(2, charset, <<0x5A>>) == "T"
    assert random_string(4, charset, <<0x5A>>) == "TT"
    assert random_string(6, charset, <<0x93>>) == "CTA"
    assert random_string(8, charset, <<0x93>>) == "CTAG"
    assert random_string(10, charset, <<0x20, 0xF1>>) == "ACAAG"
    assert random_string(12, charset, <<0x20, 0xF1>>) == "ACAAGG"
    assert random_string(14, charset, <<0x20, 0xF1>>) == "ACAAGGA"
    assert random_string(16, charset, <<0x20, 0xF1>>) == "ACAAGGAT"
  end

  test "CharSet 2" do
    charset = CharSet.charset2()
    assert random_string(1, charset, <<0x27>>) == "0"
    assert random_string(2, charset, <<0x27>>) == "00"
    assert random_string(3, charset, <<0x27>>) == "001"
    assert random_string(4, charset, <<0x27>>) == "0010"
    assert random_string(5, charset, <<0x27>>) == "00100"
    assert random_string(6, charset, <<0x27>>) == "001001"
    assert random_string(7, charset, <<0x27>>) == "0010011"
    assert random_string(8, charset, <<0x27>>) == "00100111"
    assert random_string(9, charset, <<0xE3, 0xE9>>) == "111000111"
    assert random_string(16, charset, <<0xE3, 0xE9>>) == "1110001111101001"
  end

  test "small ID" do
    assert byte_size(small_id()) == 6

    assert byte_size(small_id(CharSet.charset64())) == 5
    assert byte_size(small_id(CharSet.charset32())) == 6
    assert byte_size(small_id(CharSet.charset16())) == 8
    assert byte_size(small_id(CharSet.charset8())) == 10
    assert byte_size(small_id(CharSet.charset4())) == 15
    assert byte_size(small_id(CharSet.charset2())) == 29
  end

  test "medium ID" do
    assert byte_size(medium_id()) == 14

    assert byte_size(medium_id(CharSet.charset64())) == 12
    assert byte_size(medium_id(CharSet.charset32())) == 14
    assert byte_size(medium_id(CharSet.charset16())) == 18
    assert byte_size(medium_id(CharSet.charset8())) == 23
    assert byte_size(medium_id(CharSet.charset4())) == 35
    assert byte_size(medium_id(CharSet.charset2())) == 69
  end

  test "large ID" do
    assert byte_size(large_id()) == 20

    assert byte_size(large_id(CharSet.charset64())) == 17
    assert byte_size(large_id(CharSet.charset32())) == 20
    assert byte_size(large_id(CharSet.charset16())) == 25
    assert byte_size(large_id(CharSet.charset8())) == 33
    assert byte_size(large_id(CharSet.charset4())) == 50
    assert byte_size(large_id(CharSet.charset2())) == 99
  end

  test "session ID" do
    assert byte_size(session_id()) == 26

    assert byte_size(session_id(CharSet.charset64())) == 22
    assert byte_size(session_id(CharSet.charset32())) == 26
    assert byte_size(session_id(CharSet.charset16())) == 32
    assert byte_size(session_id(CharSet.charset8())) == 43
    assert byte_size(session_id(CharSet.charset4())) == 64
    assert byte_size(session_id(CharSet.charset2())) == 128
  end

  test "token" do
    assert byte_size(token()) == 43

    assert byte_size(token(CharSet.charset64())) == 43
    assert byte_size(token(CharSet.charset32())) == 52
    assert byte_size(token(CharSet.charset16())) == 64
    assert byte_size(token(CharSet.charset8())) == 86
    assert byte_size(token(CharSet.charset4())) == 128
    assert byte_size(token(CharSet.charset2())) == 256
  end

  test "invalid byte count" do
    {:error, _} = random_string(7, CharSet.charset64(), <<1>>)
    {:error, _} = random_string(13, CharSet.charset64(), <<1, 2>>)
    {:error, _} = random_string(25, CharSet.charset64(), <<1, 2, 3>>)
    {:error, _} = random_string(31, CharSet.charset64(), <<1, 2, 3, 4>>)

    {:error, _} = random_string(6, CharSet.charset32(), <<1>>)
    {:error, _} = random_string(16, CharSet.charset32(), <<1, 2>>)
    {:error, _} = random_string(21, CharSet.charset32(), <<1, 2, 3>>)
    {:error, _} = random_string(31, CharSet.charset32(), <<1, 2, 3, 4>>)
    {:error, _} = random_string(32, CharSet.charset32(), <<1, 2, 3, 4>>)
    {:error, _} = random_string(41, CharSet.charset32(), <<1, 2, 3, 4, 5>>)
    {:error, _} = random_string(46, CharSet.charset32(), <<1, 2, 3, 4, 5, 6>>)

    {:error, _} = random_string(9, CharSet.charset16(), <<1>>)
    {:error, _} = random_string(17, CharSet.charset16(), <<1, 2>>)

    {:error, _} = random_string(7, CharSet.charset8(), <<1>>)
    {:error, _} = random_string(16, CharSet.charset8(), <<1, 2>>)
    {:error, _} = random_string(25, CharSet.charset8(), <<1, 2, 3>>)
    {:error, _} = random_string(31, CharSet.charset8(), <<1, 2, 3, 4>>)

    {:error, _} = random_string(9, CharSet.charset4(), <<1>>)
    {:error, _} = random_string(17, CharSet.charset4(), <<1, 2>>)

    {:error, _} = random_string(9, CharSet.charset2(), <<1>>)
    {:error, _} = random_string(17, CharSet.charset2(), <<1, 2>>)
  end

  test "custom characters" do
    charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ9876543210_-"
    bytes = <<0x9D, 0x99, 0x4E, 0xA5, 0xD2, 0x3F, 0x8C, 0x86, 0x80>>
    assert random_string(72, charset, bytes) == "NzLoPDi-JiAa"

    charset = "2346789BDFGHJMNPQRTbdfghjlmnpqrt"
    bytes = <<0xD2, 0xE3, 0xE9, 0xDA, 0x19, 0x97, 0x52>>
    assert random_string(55, charset, bytes) == "mHRrbgQlTqF"

    charset = "0123456789ABCDEF"
    bytes = <<0xC7, 0xC9, 0x00>>
    assert random_string(20, charset, bytes) == "C7C90"

    charset = "abcdefgh"
    bytes = <<0xC7, 0xC9, 0x07, 0xC9>>
    assert random_string(30, charset, bytes) == "gbheeeahgc"

    charset = "atcg"
    bytes = <<0x20, 0xF1>>
    assert random_string(16, charset, bytes) == "acaaggat"

    charset = "HT"
    bytes = <<0xE3, 0xE9>>
    assert random_string(16, charset, bytes) == "TTTHHHTTTTTHTHHT"
  end

  test "invalid charset" do
    {:error, _} = random_string(10, <<"H20">>)
    {:error, _} = random_string(10, <<"H202">>)
  end
end
