defmodule CharSetTest do
  use ExUnit.Case, async: true

  doctest EntropyString.CharSet

  alias EntropyString.CharSet, as: CharSet

  @charsets [
    CharSet.charset64(),
    CharSet.charset32(),
    CharSet.charset16(),
    CharSet.charset8(),
    CharSet.charset4(),
    CharSet.charset2()
  ]
  @bits_per_byte 8

  test "bits per char" do
    testCharSet = fn charset ->
      actual = CharSet.bits_per_char(charset)
      expected = round(:math.log2(byte_size(charset)))
      assert actual == expected
    end

    Enum.each(@charsets, testCharSet)
  end

  test "bytes needed" do
    Enum.each(:lists.seq(0, 17), fn bits ->
      Enum.each(@charsets, fn charset ->
        bytesNeeded = CharSet.bytes_needed(bits, charset)
        atLeast = Float.ceil(bits / @bits_per_byte)
        assert atLeast <= bytesNeeded
        assert bytesNeeded <= atLeast + 1
      end)
    end)
  end

  test "charset length" do
    assert byte_size(CharSet.charset64()) == 64
    assert byte_size(CharSet.charset32()) == 32
    assert byte_size(CharSet.charset16()) == 16
    assert byte_size(CharSet.charset8()) == 8
    assert byte_size(CharSet.charset4()) == 4
    assert byte_size(CharSet.charset2()) == 2
  end

  test "invalid charset" do
    Enum.each(
      :lists.filter(
        fn len -> round(:math.log2(len)) != :math.log2(len) end,
        :lists.seq(1, 65)
      ),
      fn n ->
        {:error, _} = EntropyString.random(16, :binary.list_to_bin(:lists.seq(1, n)))
      end
    )
  end
end
