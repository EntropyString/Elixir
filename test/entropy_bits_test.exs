defmodule EntropyBitsTest do
  use ExUnit.Case, async: true

  # ten_p deprecated. CxTBD Remove on next major release
  import EntropyString, only: [entropy_bits: 2]
  
  test "bits for zero entropy" do
    assert entropy_bits(  0,   0) == 0
    assert entropy_bits(100,   0) == 0
    assert entropy_bits(  0, 100) == 0
    assert entropy_bits(  0,  -1) == 0
    assert entropy_bits( -1,   0) == 0
  end

  test "bits for integer total and risk" do
    assert round(entropy_bits(    10,   1000)) == 15
    assert round(entropy_bits(    10,  10000)) == 19
    assert round(entropy_bits(    10, 100000)) == 22

    assert round(entropy_bits(   100,   1000)) == 22
    assert round(entropy_bits(   100,  10000)) == 26
    assert round(entropy_bits(   100, 100000)) == 29
    
    assert round(entropy_bits(  1000,   1000)) == 29
    assert round(entropy_bits(  1000,  10000)) == 32
    assert round(entropy_bits(  1000, 100000)) == 36

    assert round(entropy_bits( 10000,   1000)) == 36
    assert round(entropy_bits( 10000,  10000)) == 39
    assert round(entropy_bits( 10000, 100000)) == 42
    
    assert round(entropy_bits(100000,   1000)) == 42
    assert round(entropy_bits(100000,  10000)) == 46
    assert round(entropy_bits(100000, 100000)) == 49

  end

  test "bits powers" do
    assert round(entropy_bits(1.0e5, 1.0e3)) == 42
    assert round(entropy_bits(1.0e5, 1.0e4)) == 46
    assert round(entropy_bits(1.0e5, 1.0e5)) == 49
  end

  test "preshing 32-bit" do
    assert round(entropy_bits(30084, 1.0e01)) == 32
    assert round(entropy_bits( 9292, 1.0e02)) == 32
    assert round(entropy_bits( 2932, 1.0e03)) == 32
    assert round(entropy_bits(  927, 1.0e04)) == 32
    assert round(entropy_bits(  294, 1.0e05)) == 32
    assert round(entropy_bits(   93, 1.0e06)) == 32
    assert round(entropy_bits(   30, 1.0e07)) == 32
    assert round(entropy_bits(   10, 1.0e08)) == 32
  end

  test "preshing 64-bit" do
    assert round(entropy_bits( 1.97e09, 1.0e01)) == 64
    assert round(entropy_bits( 6.09e08, 1.0e02)) == 64
    assert round(entropy_bits( 1.92e08, 1.0e03)) == 64
    assert round(entropy_bits( 6.07e07, 1.0e04)) == 64
    assert round(entropy_bits( 1.92e07, 1.0e05)) == 64
    assert round(entropy_bits( 6.07e06, 1.0e06)) == 64
    assert round(entropy_bits( 1.92e06, 1.0e07)) == 64
    assert round(entropy_bits(  607401, 1.0e08)) == 64
    assert round(entropy_bits(  192077, 1.0e09)) == 64
    assert round(entropy_bits(   60704, 1.0e10)) == 64
    assert round(entropy_bits(   19208, 1.0e11)) == 64
    assert round(entropy_bits(    6074, 1.0e12)) == 64
    assert round(entropy_bits(    1921, 1.0e13)) == 64
    assert round(entropy_bits(     608, 1.0e14)) == 64
    assert round(entropy_bits(     193, 1.0e15)) == 64
    assert round(entropy_bits(      61, 1.0e16)) == 64
    assert round(entropy_bits(      20, 1.0e17)) == 64
    assert round(entropy_bits(       7, 1.0e18)) == 64
  end

  test "preshing 160-bit" do
    assert round(entropy_bits(1.42e24,      2)) == 160
    assert round(entropy_bits(5.55e23,     10)) == 160
    assert round(entropy_bits(1.71e23,    100)) == 160
    assert round(entropy_bits(5.41e22,   1000)) == 160
    assert round(entropy_bits(1.71e22, 1.0e04)) == 160
    assert round(entropy_bits(5.41e21, 1.0e05)) == 160
    assert round(entropy_bits(1.71e21, 1.0e06)) == 160
    assert round(entropy_bits(5.41e20, 1.0e07)) == 160
    assert round(entropy_bits(1.71e20, 1.0e08)) == 160
    assert round(entropy_bits(5.41e19, 1.0e09)) == 160
    assert round(entropy_bits(1.71e19, 1.0e10)) == 160
    assert round(entropy_bits(5.41e18, 1.0e11)) == 160
    assert round(entropy_bits(1.71e18, 1.0e12)) == 160
    assert round(entropy_bits(5.41e17, 1.0e13)) == 160
    assert round(entropy_bits(1.71e17, 1.0e14)) == 160
    assert round(entropy_bits(5.41e16, 1.0e15)) == 160
    assert round(entropy_bits(1.71e16, 1.0e16)) == 160
    assert round(entropy_bits(5.41e15, 1.0e17)) == 160
    assert round(entropy_bits(1.71e15, 1.0e18)) == 160
  end
  
  test "NaN entropy bits" do
    assert entropy_bits( -1, 100) == NaN
    assert entropy_bits(100,  -1) == NaN
    assert entropy_bits( -1,  -1) == NaN
  end

end
