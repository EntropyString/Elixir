# MIT License
#
# Copyright (c) 2017-2018 Knoxen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

defmodule EntropyString.CharSet do
  @moduledoc """
  EntropyString CharSet functionality.

  To generating random strings, **_EntropyString_** plucks characters out of a specified
  **_CharSet_**. To facilitate efficient generation of these strings, **_EntropyString_** uses
  **_CharSet_**s with character counts that are powers of two: 2, 4, 8, 16, 32  and 64. Pre-defined
  character sets are provided and custom character sets are supported.

  ## Examples

  Pre-defined CharSet with 32 characters

      iex> EntropyString.CharSet.charset32
      "2346789bdfghjmnpqrtBDFGHJLMNPQRT"

  Entropy bits per character for **_charset64_**

      iex> charset = EntropyString.CharSet.charset64
      iex> EntropyString.CharSet.bits_per_char(charset)
      6

  Custom bytes needed to produce a string of 48 entropy bits using **_charset32_**

      iex> charset = EntropyString.CharSet.charset32
      iex> EntropyString.CharSet.bytes_needed(48, charset)
      7

  Validate custom CharSet

      iex> EntropyString.CharSet.validate(<<"HT">>)
      true

      iex> EntropyString.CharSet.validate(<<"012345">>)
      {:error, "Invalid char count: must be one of 2,4,8,16,32,64"}

      iex> EntropyString.CharSet.validate(<<"ABCB">>)
      {:error, "Chars not unique"}

  """

  ## ===============================================================================================
  ##
  ##  Module Constants
  ##
  ## ===============================================================================================
  @bitsPerByte 8

  ## ===============================================================================================
  ##
  ##  PreDefined CharSets
  ##
  ## ===============================================================================================
  @charset64 "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
  @charset32 "2346789bdfghjmnpqrtBDFGHJLMNPQRT"
  @charset16 "0123456789abcdef"
  @charset8 "01234567"
  @charset4 "ATCG"
  @charset2 "01"

  ## ===============================================================================================
  ##
  ##  Accessors for PreDefined CharSets
  ##
  ## ===============================================================================================
  @doc """
  [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5) file system and URL safe character set

      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
  """
  def charset64, do: @charset64

  @doc """
  Strings that don't look like English words and are easy to parse visually

      "2346789bdfghjmnpqrtBDFGHJLMNPQRT"

    - remove all upper and lower case vowels (including y)
    - remove all numbers that look like letters
    - remove all letters that look like numbers
    - remove all letters that have poor distinction between upper and lower case values
  """
  def charset32, do: @charset32

  @doc """
  Lowercase hexidecimal

      "0123456789abcdef"
  """
  def charset16, do: @charset16

  @doc """
  Octal characters

      "01234567"
  """
  def charset8, do: @charset8

  @doc """
  DNA alphabet

      "ATCG"

  No good reason; just wanted to get away from the obvious
  """
  def charset4, do: @charset4

  @doc """
  Binary characters

      "01"
  """
  def charset2, do: @charset2

  ## ===============================================================================================
  ##
  ##  bits_per_char/1
  ##
  ## ===============================================================================================
  @doc """
  Entropy bits per character for **_charset_**

    - **_charset_** - CharSet in use

  ## Example

      iex> charset = EntropyString.CharSet.charset32
      "2346789bdfghjmnpqrtBDFGHJLMNPQRT"
      iex> EntropyString.CharSet.bits_per_char(charset)
      5
  """
  def bits_per_char(@charset64), do: 6
  def bits_per_char(@charset32), do: 5
  def bits_per_char(@charset16), do: 4
  def bits_per_char(@charset8), do: 3
  def bits_per_char(@charset4), do: 2
  def bits_per_char(@charset2), do: 1

  def bits_per_char(charset) when is_binary(charset) do
    round(:math.log2(byte_size(charset)))
  end

  ## ===============================================================================================
  ##
  ##  bytes_needed/2
  ##
  ## ===============================================================================================
  @doc """
  Bytes needed to form a string of entropy **_bits_** from characters in **_charset_**

    - **_bits_** - entropy bits for string
    - **_charset_** - CharSet in use

  Returns number of bytes needed to form strings with entropy **_bits_** using characters from
  **_charset_**; or

    - `{:error, reason}` if `EntropyString.CharSet.validate(charset)` is not `true`.

  ## Example

      iex> charset = EntropyString.CharSet.charset16
      "0123456789abcdef"
      iex> EntropyString.CharSet.bytes_needed(48, charset)
      6
  """
  def bytes_needed(bits, _charset) when bits < 0, do: {:error, "Negative entropy"}

  def bytes_needed(bits, charset) when is_atom(bits) do
    bytes_needed(bits(bits), charset)
  end

  def bytes_needed(bits, charset) when is_atom(charset) do
    bytes_needed(bits, charset_from_atom(charset))
  end

  def bytes_needed(bits, charset) do
    bitsPerChar = bits_per_char(charset)
    charCount = round(Float.ceil(bits / bitsPerChar))
    round(Float.ceil(charCount * bitsPerChar / @bitsPerByte))
  end

  ## ===============================================================================================
  ##
  ##  validate_charset/1
  ##
  ## ===============================================================================================
  @doc """
  Validate **_charset_**

    - **_charset_** - CharSet to use

  ### Validations

    - **_charset_** must have 2, 4, 8, 16, 32, or 64 characters
    - characters must by unique

  ## Examples

      iex> EntropyString.CharSet.validate(<<"0123">>)
      true

      iex> EntropyString.CharSet.validate(<<"01234567890abcdef">>)
      {:error, "Invalid char count: must be one of 2,4,8,16,32,64"}

      iex> EntropyString.CharSet.validate(<<"01234566">>)
      {:error, "Chars not unique"}

  """
  def validate(charset) when is_binary(charset) do
    length = byte_size(charset)

    case :lists.member(length, [64, 32, 16, 8, 4, 2]) do
      true ->
        unique(charset)

      false ->
        {:error, "Invalid char count: must be one of 2,4,8,16,32,64"}
    end
  end

  ## -----------------------------------------------------------------------------------------------
  ##
  ##  unique/1
  ##
  ## -----------------------------------------------------------------------------------------------
  defp unique(charset), do: unique(true, charset)

  ## -----------------------------------------------------------------------------------------------
  ##
  ##  unique/2
  ##
  ## -----------------------------------------------------------------------------------------------
  defp unique(result, <<>>), do: result

  defp unique(true, <<head, tail::binary>>) do
    case :binary.match(tail, [<<head>>]) do
      :nomatch ->
        unique(true, tail)

      _ ->
        {:error, "Chars not unique"}
    end
  end

  defp unique(error, _), do: error

  ## These 2 functions are repeated in entropy_string.ex. I don't want these function to be
  ## public. CxTBD Is there a way to DRY these functions and not be public?

  ## -----------------------------------------------------------------------------------------------
  ##  bits/1
  ## -----------------------------------------------------------------------------------------------
  defp bits(:small), do: 29
  defp bits(:medium), do: 69
  defp bits(:large), do: 99
  defp bits(:session), do: 128
  defp bits(:token), do: 256

  ## -----------------------------------------------------------------------------------------------
  ##  Convert charset atom to EntropyString.CharSet
  ## -----------------------------------------------------------------------------------------------
  defp charset_from_atom(:charset2), do: @charset2
  defp charset_from_atom(:charset4), do: @charset4
  defp charset_from_atom(:charset8), do: @charset8
  defp charset_from_atom(:charset16), do: @charset16
  defp charset_from_atom(:charset32), do: @charset32
  defp charset_from_atom(:charset64), do: @charset64
end
