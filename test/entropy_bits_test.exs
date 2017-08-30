defmodule EntropyBitsTest do
  use ExUnit.Case, async: true

  import EntropyString, only: [entropy_bits: 2, ten_p: 1]
  
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

    ten3 = ten_p(3)
    ten4 = ten_p(4)
    ten5 = ten_p(5)
    assert round(entropy_bits(ten5, ten3)) == 42
    assert round(entropy_bits(ten5, ten4)) == 46
    assert round(entropy_bits(ten5, ten5)) == 49
  end

  test "NaN entropy bits" do
    assert entropy_bits( -1, 100) == NaN
    assert entropy_bits(100,  -1) == NaN
    assert entropy_bits( -1,  -1) == NaN
  end

end
