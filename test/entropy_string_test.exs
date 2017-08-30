defmodule EntropyStringTest do
  use ExUnit.Case, async: true

  doctest EntropyString

  alias EntropyString.CharSet, as: CharSet

  import EntropyString, only: [random_string: 2, random_string: 3, session_id: 1]

  test "CharSet 64" do
    charset = CharSet.charset64
    assert random_string(  6, charset, <<0xdd>>) == "3"
    assert random_string( 12, charset, <<0x78, 0xfc>>) == "eP"
    assert random_string(18, charset, <<0xc5, 0x6f, 0x21>>) == "xW8"
    assert random_string(24, charset, <<0xc9, 0x68, 0xc7>>) == "yWjH"
    assert random_string(30, charset, <<0xa5, 0x62, 0x20, 0x87>>) == "pWIgh"
    assert random_string(36, charset, <<0x39, 0x51, 0xca, 0xcc, 0x8b>>) == "OVHKzI"
    assert random_string(42, charset, <<0x83, 0x89, 0x00, 0xc7, 0xf4, 0x02>>) == "g4kAx_Q"
    assert random_string(48, charset, <<0x51, 0xbc, 0xa8, 0xc7, 0xc9, 0x17>>) == "Ubyox8kX"
    assert random_string(54, charset, <<0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52>>) == "0uPp2hmXU"
    assert random_string(60, charset,
      <<0xd9, 0x39, 0xc1, 0xaf, 0x1e, 0x2e, 0x69, 0x48>>) == "2TnBrx4uaU"
    assert random_string(66, charset,
      <<0x78, 0x3f, 0xfd, 0x93, 0xd1, 0x06, 0x90, 0x4b, 0xd6>>) == "eD_9k9EGkEv"
    assert random_string(72, charset,
      <<0x9d, 0x99, 0x4e, 0xa5, 0xd2, 0x3f, 0x8c, 0x86, 0x80>>) == "nZlOpdI_jIaA"
  end

  test "CharSet 32" do
    charset = CharSet.charset32
    assert random_string( 5, charset, <<0xdd>>) == "N"
    assert random_string(10, charset, <<0x78, 0xfc>>) == "p6"
    assert random_string(15, charset, <<0x78, 0xfc>>) == "p6R"
    assert random_string(20, charset, <<0xc5, 0x6f, 0x21>>) == "JFHt"
    assert random_string(25, charset, <<0xa5, 0x62, 0x20, 0x87>>) == "DFr43"
    assert random_string(30, charset, <<0xa5, 0x62, 0x20, 0x87>>) == "DFr433"
    assert random_string(35, charset, <<0x39, 0x51, 0xca, 0xcc, 0x8b>>) == "b8dPFB7"
    assert random_string(40, charset, <<0x39, 0x51, 0xca, 0xcc, 0x8b>>) == "b8dPFB7h"
    assert random_string(45, charset, <<0x83, 0x89, 0x00, 0xc7, 0xf4, 0x02>>) == "qn7q3rTD2"
    assert random_string(50, charset, <<0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52>>) == "MhrRBGqLtQ"
    assert random_string(55, charset, <<0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52>>) == "MhrRBGqLtQf"
  end

  test "CharSet 16" do
    charset = CharSet.charset16
    assert random_string( 4, charset, <<0x9d>>) == "9"
    assert random_string( 8, charset, <<0xae>>) == "ae"
    assert random_string(12, charset, <<0x01, 0xf2>>) == "01f"
    assert random_string(16, charset, <<0xc7, 0xc9>>) == "c7c9"
    assert random_string(20, charset, <<0xc7, 0xc9, 0x00>>) == "c7c90"
  end

  test "CharSet 8" do
    charset = CharSet.charset8
    assert random_string( 3, charset, <<0x5a>>) == "2"
    assert random_string( 6, charset, <<0x5a>>) == "26"
    assert random_string( 9, charset, <<0x21, 0xa4>>) == "103"
    assert random_string(12, charset, <<0x21, 0xa4>>) == "1032"
    assert random_string(15, charset, <<0xda, 0x19>>) == "66414"
    assert random_string(18, charset, <<0xfd, 0x93, 0xd1>>) == "773117"
    assert random_string(21, charset, <<0xfd, 0x93, 0xd1>>) == "7731172"
    assert random_string(24, charset, <<0xfd, 0x93, 0xd1>>) == "77311721"
    assert random_string(27, charset, <<0xc7, 0xc9, 0x07, 0xc9>>) == "617444076"
    assert random_string(30, charset, <<0xc7, 0xc9, 0x07, 0xc9>>) == "6174440762"
  end

  test "CharSet 4" do
    charset = CharSet.charset4
    assert random_string( 2, charset, <<0x5a>>) == "T"
    assert random_string( 4, charset, <<0x5a>>) == "TT"
    assert random_string( 6, charset, <<0x93>>) == "CTA"
    assert random_string( 8, charset, <<0x93>>) == "CTAG"
    assert random_string(10, charset, <<0x20, 0xf1>>) == "ACAAG"
    assert random_string(12, charset, <<0x20, 0xf1>>) == "ACAAGG"
    assert random_string(14, charset, <<0x20, 0xf1>>) == "ACAAGGA"
    assert random_string(16, charset, <<0x20, 0xf1>>) == "ACAAGGAT"
  end

  test "CharSet 2" do
    charset = CharSet.charset2
    assert random_string( 1, charset, <<0x27>>) == "0"
    assert random_string( 2, charset, <<0x27>>) == "00"
    assert random_string( 3, charset, <<0x27>>) == "001"
    assert random_string( 4, charset, <<0x27>>) == "0010"
    assert random_string( 5, charset, <<0x27>>) == "00100"
    assert random_string( 6, charset, <<0x27>>) == "001001"
    assert random_string( 7, charset, <<0x27>>) == "0010011"
    assert random_string( 8, charset, <<0x27>>) == "00100111"
    assert random_string( 9, charset, <<0xe3, 0xe9>>) == "111000111"
    assert random_string(16, charset, <<0xe3, 0xe9>>) == "1110001111101001"
  end

  test "session ID" do
    assert byte_size(session_id(CharSet.charset64)) ==  22
    assert byte_size(session_id(CharSet.charset32)) ==  26
    assert byte_size(session_id(CharSet.charset16)) ==  32
    assert byte_size(session_id(CharSet.charset8)) ==   43
    assert byte_size(session_id(CharSet.charset4)) ==   64
    assert byte_size(session_id(CharSet.charset2)) ==  128
  end

  test "invalid byte count" do
    {:error, _} = random_string( 7, CharSet.charset64, <<1>>)
    {:error, _} = random_string(13, CharSet.charset64, <<1,2>>)
    {:error, _} = random_string(25, CharSet.charset64, <<1,2,3>>)
    {:error, _} = random_string(31, CharSet.charset64, <<1,2,3,4>>)

    {:error, _} = random_string( 6, CharSet.charset32, <<1>>)
    {:error, _} = random_string(16, CharSet.charset32, <<1,2>>)
    {:error, _} = random_string(21, CharSet.charset32, <<1,2,3>>)
    {:error, _} = random_string(31, CharSet.charset32, <<1,2,3,4>>)
    {:error, _} = random_string(32, CharSet.charset32, <<1,2,3,4>>)
    {:error, _} = random_string(41, CharSet.charset32, <<1,2,3,4,5>>)
    {:error, _} = random_string(46, CharSet.charset32, <<1,2,3,4,5,6>>)

    {:error, _} = random_string( 9, CharSet.charset16, <<1>>)
    {:error, _} = random_string(17, CharSet.charset16, <<1,2>>)

    {:error, _} = random_string( 7, CharSet.charset8, <<1>>)
    {:error, _} = random_string(16, CharSet.charset8, <<1,2>>)
    {:error, _} = random_string(25, CharSet.charset8, <<1,2,3>>)
    {:error, _} = random_string(31, CharSet.charset8, <<1,2,3,4>>)

    {:error, _} = random_string( 9, CharSet.charset4, <<1>>)
    {:error, _} = random_string(17, CharSet.charset4, <<1,2>>)

    {:error, _} = random_string( 9, CharSet.charset2, <<1>>)
    {:error, _} = random_string(17, CharSet.charset2, <<1,2>>)
  end

  test "custom characters" do
    charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ9876543210_-"
    bytes = <<0x9d, 0x99, 0x4e, 0xa5, 0xd2, 0x3f, 0x8c, 0x86, 0x80>>
    assert random_string(72, charset, bytes) == "NzLoPDi-JiAa"

    charset = "2346789BDFGHJMNPQRTbdfghjlmnpqrt"
    bytes = <<0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52>>
    assert random_string(55, charset, bytes) == "mHRrbgQlTqF"

    charset = "0123456789ABCDEF"
    bytes = <<0xc7, 0xc9, 0x00>>
    assert random_string(20, charset, bytes) == "C7C90"

    charset = "abcdefgh"
    bytes = <<0xc7, 0xc9, 0x07, 0xc9>>
    assert random_string(30, charset, bytes) == "gbheeeahgc"

    charset = "atcg"
    bytes = <<0x20, 0xf1>>
    assert random_string(16, charset, bytes) == "acaaggat"

    charset = "HT"
    bytes = <<0xe3, 0xe9>>
    assert random_string(16, charset, bytes) == "TTTHHHTTTTTHTHHT"
  end

  test "invalid charset" do
    {:error, _} = random_string(10, <<"H20">>)
    {:error, _} = random_string(10, <<"H202">>)
  end

end
