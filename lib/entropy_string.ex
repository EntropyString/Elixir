# MIT License
#
# Copyright (c) 2017 Knoxen
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

defmodule EntropyString do

  alias EntropyString.CharSet, as: CharSet

  @moduledoc """
  Efficiently generate cryptographically strong random strings of specified entropy from various
  character sets.

  ## Example

  Ten thousand potential hexidecimal strings with a 1 in 10 million chance of repeat

      bits = EntropyString.Entropy.bits(10000, 10000000)
      charSet = EntropyString.CharSet.charset16
      string = EntropyString.random_string(bits, charSet)

      "9e9b34d6f69ea"

  """

  @doc false
  defmacro __using__(opts) do
    quote do

      import EntropyString
      import EntropyString.CharSet

      charset =
        case unquote(opts)[:charset] do
          nil -> CharSet.charset32
          charset ->
            case validate(charset) do
              true -> charset
              {_, reason} -> raise reason
            end
        end
      
      @entropy_string_charset charset

      @before_compile EntropyString
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      def small_id, do: small_id(@entropy_string_charset)
      def medium_id, do: medium_id(@entropy_string_charset)
      def large_id, do: large_id(@entropy_string_charset)
      def session_id, do: session_id(@entropy_string_charset)
      def token, do: token(@entropy_string_charset)
      def random_string(bits), do: random_string(bits, @entropy_string_charset)
      def charset, do: @entropy_string_charset
    end
  end

  ##================================================================================================
  ##
  ## ten_p/1
  ##
  ##================================================================================================
  @doc """
  Convenience for specifying **_total_** number of strings or acceptable associated **_risk_** as
  power of ten.

  ## Example

      iex> import EntropyString, only: [ten_p: 1]
      iex> ten_p(12)
      1.0e12
  """
  def ten_p(power), do: :math.pow(10, power)

  ##================================================================================================
  ##
  ## bits/2
  ##
  ##================================================================================================
  @doc """
  Entropy bits required for **_total_** number of strings with a given **_risk_**

    - **_total_** - potential number of strings
    - **_risk_**  - risk of repeat in **_total_** strings

  ## Example

  Entropy bits required for **_30_** strings with a **_1 in a million_** chance of repeat

      iex> import EntropyString, only: [entropy_bits: 2]
      iex> bits = entropy_bits(30, 1000000)
      iex> round(bits)
      29
  """
  def entropy_bits(0, _), do: 0
  def entropy_bits(_, 0), do: 0
  def entropy_bits(total, _) when total < 0, do: NaN
  def entropy_bits(_, risk)  when risk  < 0, do: NaN
  def entropy_bits(total, risk) when is_number(total) and is_number(risk) do
    n = cond do
      total < 1000 ->
        :math.log2(total) + :math.log2(total-1)
      true ->
        2 * :math.log2(total)
    end
    n + :math.log2(risk) - 1
  end
  def entropy_bits(_, _), do: NaN

  ##================================================================================================
  ##
  ## small_id/1
  ##
  ##================================================================================================
  @doc """
  Random string using **_charset_** characters with a 1 in a million chance of repeat for a
  potential of 30 strings.

  Default **_CharSet_** is `CharSet.charset32`.

  ## Example

      charSet = EntropyString.CharSet.charset32
      small_id = EntropyString.small_id(charSet)

      "nGrqnt"
  """
  def small_id(charset) do
    random_string(29, charset)
  end

  ##================================================================================================
  ##
  ## medium_id/1
  ##
  ##================================================================================================
  @doc """
  Random string using **_charset_** characters with a 1 in a billion chance of repeat for a
  potential of a million strings.

  ## Example

      charSet = EntropyString.CharSet.charset32
      medium_id = EntropyString.small_id(charSet)

      "nndQjL7FLR9pDd"
  """
  def medium_id(charset) do
    random_string(69, charset)
  end

  ##================================================================================================
  ##
  ## large_id/1
  ##
  ##================================================================================================
  @doc """
  Random string using **_charset_** characters with a 1 in a trillion chance of repeat for a
  potential of a billion strings.

  Default **_CharSet_** is `CharSet.charset32`.

  ## Example

      charSet = EntropyString.CharSet.charset32
      large_id = EntropyString.small_id(charSet)

      "NqJLbG8htr4t64TQmRDB"
  """
  def large_id(charset) do
    random_string(99, charset)
  end

  ##================================================================================================
  ##
  ## session_id/1
  ##
  ##================================================================================================
  @doc """
  Random string using **_charset_** characters suitable for 128-bit OWASP Session ID

  ## Example

      charSet = EntropyString.CharSet.charset32
      session_id = EntropyString.session_id(charSet)

      "6pLfLgfL8MgTn7tQDN8tqPFR4b"
  """
  def session_id(charset) do
    random_string(128, charset)
  end

  ##================================================================================================
  ##
  ## token/1
  ##
  ##================================================================================================
  @doc """
  Random string using **_charset_** characters with 256 entropy bits. 

  Default **_CharSet_** is the base 64 URL and file system safe character set.

  ## Example

      token = EntropyString.token

      "6pLfLgfL8MgTn7tQDN8tqPFR4b"
  """
  def token(charset \\ CharSet.charset64) do
    random_string(256, charset)
  end

  ##================================================================================================
  ##
  ## random_string/2
  ##
  ##================================================================================================
  @doc """
  Random string of entropy **_bits_** using **_charset_** characters

    - **_bits_** - entropy bits for string
    - **_charset_** - CharSet to use

  Returns string of at least entropy **_bits_** using characters from **_charset_**; or

    - `{:error, "Negative entropy"}` if **_bits_** is negative.
    - `{:error, reason}` if `EntropyString.CharSet.validate(charset)` is not `true`.

  Since the generated random strings carry an entropy that is a multiple of the bits per character
  for **_charset_**, the returned entropy is the minimum that equals or exceeds the specified
  **_bits_**.

  Default **_CharSet_** is `CharSet.charset32`.

  ## Example

  A million potential base32 strings with a 1 in a billion chance of a repeat

      total = EntropyString.ten_p(6)
      risk = EntropyString.ten_p(9)
      bits = EntropyString.entropy_bits(total, risk)
      charSet = EntropyString.CharSet.charset32
      string = EntropyString.random_string(bits, charSet)

      "NbMbLrj9fBbQP6"
  """
  def random_string(bits, charset \\ EntropyString.CharSet.charset32)
  ##------------------------------------------------------------------------------------------------
  ## Invalid bits
  ##------------------------------------------------------------------------------------------------
  def random_string(bits, _charset) when bits < 0, do: {:error, "Negative entropy"}

  ##------------------------------------------------------------------------------------------------
  ## Call _random_string/2 if valid charset
  ##------------------------------------------------------------------------------------------------
  def random_string(bits, charset) do
    with_charset(charset,
      fn() ->
        byteCount = CharSet.bytes_needed(bits, charset)
        bytes = :crypto.strong_rand_bytes(byteCount)
        _random_string_bytes(bits, charset, bytes)
      end
    )
  end

  ##================================================================================================
  ##
  ## random_string/3
  ##
  ##================================================================================================
  @doc """
  Random string of entropy **_bits_** using **_charset_** characters and specified **_bytes_**

    - **_bits_** - entropy bits for string
    - **_charset_** - CharSet to use
    - **_bytes_** - Bytes to use

  Returns random string of at least entropy **_bits_**; or

    - `{:error, "Negative entropy"}` if **_bits_** is negative.
    - `{:error, reason}` if `EntropyString.CharSet.validate(charset)` is not `true`.
    - `{:error, reason}` if `validate_byte_count(bits, charset, bytes)` is not `true`.

  Since the generated random strings carry an entropy that is a multiple of the bits per character
  for **_charset_**, the returned entropy is the minimum that equals or exceeds the specified
  **_bits_**.

  ## Example

  30 potential random hex strings with a 1 in a million chance of a repeat

      iex> bits = EntropyString.entropy_bits(30, 1000000)
      iex> charSet = EntropyString.CharSet.charset16
      iex> bytes = <<14, 201, 32, 143>>
      iex> EntropyString.random_string(bits, charSet, bytes)
      "0ec9208f"

  Use `EntropyString.CharSet.bytes_needed(bits, charset)` to determine how many **_bytes_** are
  actually needed.
  """
  def random_string(bits, charset, bytes) do
    with_charset(charset,
      fn() ->
        case validate_byte_count(bits, charset, bytes) do
          true -> _random_string_bytes(bits, charset, bytes)
          error -> error
        end
      end
    )
  end

  defp _random_string_bytes(bits, charset, bytes) do
    # Require for travis CI
    Code.ensure_loaded(:math)
    
    bitsPerChar = CharSet.bits_per_char(charset)
    ndxFn = ndx_fn(charset)
    charCount = trunc(:math.ceil(bits / bitsPerChar))
    _random_string_count(charCount, ndxFn, charset, bytes, <<>>)
  end

  defp _random_string_count(0, _, _, _, chars), do: chars
  defp _random_string_count(charCount, ndxFn, charset, bytes, chars) do
    slice = charCount - 1
    ndx = ndxFn.(slice, bytes)
    char = :binary.part(charset, ndx, 1)
    _random_string_count(slice, ndxFn, charset, bytes, <<char :: binary, chars :: binary>>)
  end

  ##================================================================================================
  ##
  ## validate_byte_count/3
  ##
  ##================================================================================================
  @doc """
  Validate number of **_bytes_** is sufficient to generate random strings with entropy **_bits_**
  using **_charset_**

    - **_bits_** - entropy bits for random string
    - **_charset_** - characters in use
    - **_bytes_** - bytes to validate

  ### Validations

    - **_bytes_** count must be sufficient to generate entropy **_bits_** string from **_charset_**

  Use `EntropyString.CharSet.bytes_needed(bits, charset)` to determine how many **_bytes_** are needed
  """
  def validate_byte_count(bits, charset, bytes) when is_binary(bytes) do
    need = CharSet.bytes_needed(bits, charset)
    got = byte_size(bytes)
    case need <= got do
      true -> true
      _ ->
        reason = :io_lib.format("Insufficient bytes: need ~p and got ~p", [need, got])
        {:error, :binary.list_to_bin(reason)}
    end
  end

  ##================================================================================================
  ##
  ## ndx_fn/1
  ##
  ## Return function to pull charset bits_per_char bits at position slice of bytes
  ##
  ##================================================================================================
  defp ndx_fn(charset) do
    bitsPerChar = CharSet.bits_per_char(charset)
    fn(slice, bytes) ->
      offset = slice * bitsPerChar
      << _skip :: size(offset), ndx :: size(bitsPerChar), _rest :: bits>> = bytes
      ndx
    end
  end

  ##================================================================================================
  ##
  ## with_charset/1
  ##
  ## For pre-defined CharSet, skip charset validation
  ##
  ##================================================================================================
  defp with_charset(charset, doFn) do
    # Pre-defined charset does not require validation
    case is_predefined_charset(charset) do
      true -> doFn.()
      _ ->
        case CharSet.validate(charset) do
          true -> doFn.()
          error -> error
        end
    end
  end

  defp is_predefined_charset(charset) do
    charset == CharSet.charset64 or
    charset == CharSet.charset32 or
    charset == CharSet.charset16 or
    charset == CharSet.charset8  or
    charset == CharSet.charset4  or
    charset == CharSet.charset2
  end


end
