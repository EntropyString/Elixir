defmodule EntropypString.Bits.Test do
  use ExUnit.Case, async: true

  import EntropyString, only: [bits: 2]

  test "bits for zero entropy" do
    assert bits(0, 0) == 0
    assert bits(100, 0) == 0
    assert bits(0, 100) == 0
    assert bits(0, -1) == 0
    assert bits(-1, 0) == 0
  end

  test "bits for integer total and risk" do
    assert round(bits(10, 1000)) == 15
    assert round(bits(10, 10000)) == 19
    assert round(bits(10, 100_000)) == 22

    assert round(bits(100, 1000)) == 22
    assert round(bits(100, 10000)) == 26
    assert round(bits(100, 100_000)) == 29

    assert round(bits(1000, 1000)) == 29
    assert round(bits(1000, 10000)) == 32
    assert round(bits(1000, 100_000)) == 36

    assert round(bits(10000, 1000)) == 36
    assert round(bits(10000, 10000)) == 39
    assert round(bits(10000, 100_000)) == 42

    assert round(bits(100_000, 1000)) == 42
    assert round(bits(100_000, 10000)) == 46
    assert round(bits(100_000, 100_000)) == 49
  end

  test "bits powers" do
    assert round(bits(1.0e5, 1.0e3)) == 42
    assert round(bits(1.0e5, 1.0e4)) == 46
    assert round(bits(1.0e5, 1.0e5)) == 49
  end

  test "preshing 32-bit" do
    assert round(bits(30084, 1.0e01)) == 32
    assert round(bits(9292, 1.0e02)) == 32
    assert round(bits(2932, 1.0e03)) == 32
    assert round(bits(927, 1.0e04)) == 32
    assert round(bits(294, 1.0e05)) == 32
    assert round(bits(93, 1.0e06)) == 32
    assert round(bits(30, 1.0e07)) == 32
    assert round(bits(10, 1.0e08)) == 32
  end

  test "preshing 64-bit" do
    assert round(bits(1.97e09, 1.0e01)) == 64
    assert round(bits(6.09e08, 1.0e02)) == 64
    assert round(bits(1.92e08, 1.0e03)) == 64
    assert round(bits(6.07e07, 1.0e04)) == 64
    assert round(bits(1.92e07, 1.0e05)) == 64
    assert round(bits(6.07e06, 1.0e06)) == 64
    assert round(bits(1.92e06, 1.0e07)) == 64
    assert round(bits(607_401, 1.0e08)) == 64
    assert round(bits(192_077, 1.0e09)) == 64
    assert round(bits(60704, 1.0e10)) == 64
    assert round(bits(19208, 1.0e11)) == 64
    assert round(bits(6074, 1.0e12)) == 64
    assert round(bits(1921, 1.0e13)) == 64
    assert round(bits(608, 1.0e14)) == 64
    assert round(bits(193, 1.0e15)) == 64
    assert round(bits(61, 1.0e16)) == 64
    assert round(bits(20, 1.0e17)) == 64
    assert round(bits(7, 1.0e18)) == 64
  end

  test "preshing 160-bit" do
    assert round(bits(1.42e24, 2)) == 160
    assert round(bits(5.55e23, 10)) == 160
    assert round(bits(1.71e23, 100)) == 160
    assert round(bits(5.41e22, 1000)) == 160
    assert round(bits(1.71e22, 1.0e04)) == 160
    assert round(bits(5.41e21, 1.0e05)) == 160
    assert round(bits(1.71e21, 1.0e06)) == 160
    assert round(bits(5.41e20, 1.0e07)) == 160
    assert round(bits(1.71e20, 1.0e08)) == 160
    assert round(bits(5.41e19, 1.0e09)) == 160
    assert round(bits(1.71e19, 1.0e10)) == 160
    assert round(bits(5.41e18, 1.0e11)) == 160
    assert round(bits(1.71e18, 1.0e12)) == 160
    assert round(bits(5.41e17, 1.0e13)) == 160
    assert round(bits(1.71e17, 1.0e14)) == 160
    assert round(bits(5.41e16, 1.0e15)) == 160
    assert round(bits(1.71e16, 1.0e16)) == 160
    assert round(bits(5.41e15, 1.0e17)) == 160
    assert round(bits(1.71e15, 1.0e18)) == 160
  end

  test "NaN entropy bits" do
    assert bits(-1, 100) == NaN
    assert bits(100, -1) == NaN
    assert bits(-1, -1) == NaN
  end

  test "module entropy total/risk" do
    defmodule(TotalRiskId, do: use(EntropyString, total: 10_000_000, risk: 10.0e12))
    assert round(TotalRiskId.bits()) == 89
  end

  test "module entropy bits" do
    defmodule(BitsId, do: use(EntropyString, bits: 96))
    assert BitsId.bits() == 96
  end
end
