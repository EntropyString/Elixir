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

defmodule EntropyString.Error do
  @moduledoc """
  Errors raised when defining a EntropyString module with invalid options
  """
  defexception message: "EntropyString error"
end

defmodule EntropyString do
  alias EntropyString.CharSet

  @moduledoc """
  Efficiently generate cryptographically strong random strings of specified entropy from various
  character sets.

  ## Example

  Ten thousand potential hexidecimal strings with a 1 in 10 million chance of repeat

      bits = EntropyString.bits(10000, 10000000)
      EntropyString.random(bits, :charset16)
      "9e9b34d6f69ea"

  """

  @doc false
  defmacro __using__(opts) do
    quote do
      import EntropyString
      import CharSet

      bitLen = unquote(opts)[:bits]
      total = unquote(opts)[:total]
      risk = unquote(opts)[:risk]

      bits =
        cond do
          is_number(bitLen) ->
            bitLen

          is_number(total) and is_number(risk) ->
            EntropyString.bits(total, risk)

          true ->
            128
        end

      @entropy_string_bits bits

      charset =
        case unquote(opts)[:charset] do
          nil ->
            CharSet.charset32()

          :charset64 ->
            CharSet.charset64()

          :charset32 ->
            CharSet.charset32()

          :charset16 ->
            CharSet.charset16()

          :charset8 ->
            CharSet.charset8()

          :charset4 ->
            CharSet.charset4()

          :charset2 ->
            CharSet.charset2()

          charset when is_binary(charset) ->
            case validate(charset) do
              true -> charset
              {_, reason} -> raise EntropyString.Error, message: reason
            end

          charset ->
            raise EntropyString.Error, message: "Invalid predefined charset: #{charset}"
        end

      @entropy_string_charset charset

      @before_compile EntropyString
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      @doc """
      Default entropy bits for random strings
      """
      def bits, do: @entropy_string_bits

      @doc """
      Module **_EntropyString.CharSet_**
      """
      def charset, do: @entropy_string_charset

      @doc """
      Random string using module **_charset_** with a 1 in a million chance of repeat in
      30 strings.

      ## Example
          MyModule.small()
          "nGrqnt"
      """
      def small, do: small(@entropy_string_charset)

      @doc """
      Random string using module **_charset_** with a 1 in a billion chance of repeat for a million
      potential strings.

      ## Example
          MyModulue.medium()
          "nndQjL7FLR9pDd"
      """
      def medium, do: medium(@entropy_string_charset)

      @doc """
      Random string using module **_charset_** with a 1 in a trillion chance of repeat for a billion
      potential strings.

      ## Example
          MyModule.large()
          "NqJLbG8htr4t64TQmRDB"
      """
      def large, do: large(@entropy_string_charset)

      @doc """
      Random string using module **_charset_** suitable for 128-bit OWASP Session ID

      ## Example
          MyModule.session()
          "6pLfLgfL8MgTn7tQDN8tqPFR4b"
      """
      def session, do: session(@entropy_string_charset)

      @doc """
      Random string using module **_charset_** with 256 bits of entropy.

      ## Example
          MyModule.token()
          "zHZ278Pv_GaOsmRYdBIR5uO8Tt0OWSESZbVuQye6grt"
      """
      def token, do: token(@entropy_string_charset)

      @doc """
      Random string of entropy **_bits_** using module **_charset_**

        - **_bits_** - entropy bits for string
          - non-negative integer
          - predefined atom
          - Defaults to module **_bits_**

      Returns string of at least entropy **_bits_** using module characters; or

        - `{:error, "Negative entropy"}` if **_bits_** is negative.
        - `{:error, reason}` if `EntropyString.CharSet.validate(charset)` is not `true`.

      Since the generated random strings carry an entropy that is a multiple of the bits per module
      characters, the returned entropy is the minimum that equals or exceeds the specified
      **_bits_**.

      ## Example

      A million potential strings (assuming :charset32 characters) with a 1 in a billion chance
      of a repeat

          bits = EntropyString.bits(1.0e6, 1.0e9)

          MyModule.random(bits)
          "NbMbLrj9fBbQP6"

          MyModule.random(:session)
          "CeElDdo7HnNDuiWwlFPPq0"

      """
      def random(bits \\ @entropy_string_bits), do: random(bits, @entropy_string_charset)

      @doc """
      Random string of module entropy **_bits_** and **_charset_**

      ## Example

      Define a module for 10 billion strings with a 1 in a decillion chance of a repeat

          defmodule Rare, do: use EntropyString, total: 1.0e10, risk: 1.0e33

          Rare.string()
          "H2Mp8MPT7F3Pp2bmHm"

      Define a module for strings with 122 bits of entropy

          defmodule MyId, do: use EntropyString, bits: 122, charset: charset64

          MyId.string()
          "aj2_kMH64P2QDRBlOkz7Z"

      """
      @since "1.3"
      def string(), do: random(@entropy_string_bits, @entropy_string_charset)

      @doc """
      Module characters
      """
      @since "1.3"
      def chars(), do: @entropy_string_charset
    end
  end

  ## -----------------------------------------------------------------------------------------------
  ##  bits/2
  ## -----------------------------------------------------------------------------------------------
  @doc """
  Bits of entropy required for **_total_** number of strings with a given **_risk_**

    - **_total_** - potential number of strings
    - **_risk_**  - risk of repeat in **_total_** strings

  ## Example

  Bits of entropy for **_30_** strings with a **_1 in a million_** chance of repeat

      iex> import EntropyString, only: [bits: 2]
      iex> bits = bits(30, 1000000)
      iex> round(bits)
      29
  """
  @since "1.0"
  def bits(0, _), do: 0
  def bits(_, 0), do: 0
  def bits(total, _) when total < 0, do: NaN
  def bits(_, risk) when risk < 0, do: NaN

  def bits(total, risk) when is_number(total) and is_number(risk) do
    n =
      cond do
        total < 1000 ->
          :math.log2(total) + :math.log2(total - 1)

        true ->
          2 * :math.log2(total)
      end

    n + :math.log2(risk) - 1
  end

  def bits(_, _), do: NaN

  ## -----------------------------------------------------------------------------------------------
  ##  small/1
  ## -----------------------------------------------------------------------------------------------
  @doc """
  Random string using **_charset_** characters with a 1 in a million chance of repeat in 30 strings.

  Default **_CharSet_** is `charset32`.

  ## Example
      EntropyString.small()
      "nGrqnt"

      EntropyString.small(:charset16)
      "7bc250e5"

  """
  @since "1.1.0"
  def small(charset \\ :charset32)

  def small(charset) when is_atom(charset) do
    random(bits_from_atom(:small), charset_from_atom(charset))
  end

  def small(charset), do: random(bits_from_atom(:small), charset)

  ## -----------------------------------------------------------------------------------------------
  ##  medium/1
  ## -----------------------------------------------------------------------------------------------
  @doc """
  Random string using **_charset_** characters with a 1 in a billion chance of repeat for a million
  potential strings.

  Default **_CharSet_** is `charset32`.

  ## Example
      EntropyString.medium()
      "nndQjL7FLR9pDd"

      EntropyString.medium(:charset16)
      "b95d23b299eeb9bbe6"

  """
  @since "1.1.0"
  def medium(charset \\ :charset32)

  def medium(charset) when is_atom(charset) do
    random(bits_from_atom(:medium), charset_from_atom(charset))
  end

  def medium(charset), do: random(bits_from_atom(:medium), charset)

  ## -----------------------------------------------------------------------------------------------
  ##  large/1
  ## -----------------------------------------------------------------------------------------------
  @doc """
  Random string using **_charset_** characters with a 1 in a trillion chance of repeat for a billion
  potential strings.

  Default **_CharSet_** is `charset32`.

  ## Example

      EntropyString.large()
      "NqJLbG8htr4t64TQmRDB"

      EntropyString.large(:charset16)
      "f6c4d04cef266a5c3a7950f90"
  """
  @since "1.1.0"
  def large(charset \\ :charset32)

  def large(charset) when is_atom(charset) do
    random(bits_from_atom(:large), charset_from_atom(charset))
  end

  def large(charset), do: random(bits_from_atom(:large), charset)

  ## -----------------------------------------------------------------------------------------------
  ##  session/1
  ## -----------------------------------------------------------------------------------------------
  @doc """
  Random string using **_charset_** characters suitable for 128-bit OWASP Session ID

  Default **_CharSet_** is `charset32`.

  ## Example

      EntropyString.session()
      "6pLfLgfL8MgTn7tQDN8tqPFR4b"

      EntropyString.session(:charset64)
      "VzhprMROlM6Iy2Pk1IRCqR"
  """
  @since "1.1.0"
  def session(charset \\ :charset32)

  def session(charset) when is_atom(charset) do
    random(bits_from_atom(:session), charset_from_atom(charset))
  end

  def session(charset), do: random(bits_from_atom(:session), charset)

  ## -----------------------------------------------------------------------------------------------
  ##  token/1
  ## -----------------------------------------------------------------------------------------------
  @doc """
  Random string using **_charset_** characters with 256 bits of entropy.

  Default **_CharSet_** is the base 64 URL and file system safe character set.

  ## Example

      EntropyString.token()
      "zHZ278Pv_GaOsmRYdBIR5uO8Tt0OWSESZbVuQye6grt"

      EntropyString.token(:charset32)
      "7fRgrB4JtqQB8gphhf8T7bppttJQqJ3PTPFjMjGQbhgJNR9FNNHD"
  """
  def token(charset \\ CharSet.charset64())

  def token(charset) when is_atom(charset) do
    random(bits_from_atom(:token), charset_from_atom(charset))
  end

  def token(charset), do: random(bits_from_atom(:token), charset)

  ## -----------------------------------------------------------------------------------------------
  ##  random/2
  ## -----------------------------------------------------------------------------------------------
  @doc """
  Random string of entropy **_bits_** using **_charset_** characters

    - **_bits_** - entropy bits for string
       - non-negative integer
       - predefined atom
    - **_charset_** - CharSet to use
       - `EntropyString.CharSet`
       - predefined atom
       - Valid `String` representing the characters for the `EntropyString.CharSet`

  Returns string of at least entropy **_bits_** using characters from **_charset_**; or

    - `{:error, "Negative entropy"}` if **_bits_** is negative.
    - `{:error, reason}` if `EntropyString.CharSet.validate(charset)` is not `true`.

  Since the generated random strings carry an entropy that is a multiple of the bits per character
  for **_charset_**, the returned entropy is the minimum that equals or exceeds the specified
  **_bits_**.

  ## Examples

  A million potential base32 strings with a 1 in a billion chance of a repeat

      bits = EntropyString.bits(1.0e6, 1.0e9)
      EntropyString.random(bits)
      "NbMbLrj9fBbQP6"

  A million potential hex strings with a 1 in a billion chance of a repeat

      EntropyString.random(bits, :charset16)
      "0746ae8fbaa2fb4d36"

  A random session ID using URL and File System safe characters

      EntropyString.random(:session, :charset64)
      "txSdE3qBK2etQtLyCFNHGD"

  """
  def random(bits \\ 128, charset \\ :charset32)

  ## -----------------------------------------------------------------------------------------------
  ##  Invalid bits
  ## -----------------------------------------------------------------------------------------------
  def random(bits, _charset) when bits < 0, do: {:error, "Negative entropy"}

  def random(bits, charset) when is_atom(bits), do: random(bits_from_atom(bits), charset)

  def random(bits, charset) when is_atom(charset), do: random(bits, charset_from_atom(charset))

  def random(bits, charset) do
    with_charset(charset, fn ->
      byteCount = CharSet.bytes_needed(bits, charset)
      bytes = :crypto.strong_rand_bytes(byteCount)
      _random_string_bytes(bits, charset, bytes)
    end)
  end

  ## -----------------------------------------------------------------------------------------------
  ##  random/3
  ## -----------------------------------------------------------------------------------------------
  @doc """
  Random string of entropy **_bits_** using **_charset_** characters and specified **_bytes_**

    - **_bits_** - entropy bits
       - non-negative integer
       - predefined atom
    - **_charset_** - CharSet to use
       - `EntropyString.CharSet`
       - predefined atom
       - Valid `String` representing the characters for the `EntropyString.CharSet`
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

      iex> bits = EntropyString.bits(30, 1000000)
      iex> bytes = <<14, 201, 32, 143>>
      iex> EntropyString.random(bits, :charset16, bytes)
      "0ec9208f"

  Use `EntropyString.CharSet.bytes_needed(bits, charset)` to determine how many **_bytes_** are
  actually needed.
  """
  def random(bits, charset, bytes) when is_atom(bits) do
    random(bits_from_atom(bits), charset, bytes)
  end

  def random(bits, charset, bytes) when is_atom(charset) do
    random(bits, charset_from_atom(charset), bytes)
  end

  def random(bits, charset, bytes) do
    with_charset(charset, fn ->
      case validate_byte_count(bits, charset, bytes) do
        true -> _random_string_bytes(bits, charset, bytes)
        error -> error
      end
    end)
  end

  defp _random_string_bytes(bits, charset, bytes) do
    bitsPerChar = CharSet.bits_per_char(charset)
    ndxFn = ndx_fn(charset)
    charCount = trunc(Float.ceil(bits / bitsPerChar))
    _random_string_count(charCount, ndxFn, charset, bytes, <<>>)
  end

  defp _random_string_count(0, _, _, _, chars), do: chars

  defp _random_string_count(charCount, ndxFn, charset, bytes, chars) do
    slice = charCount - 1
    ndx = ndxFn.(slice, bytes)
    char = :binary.part(charset, ndx, 1)
    _random_string_count(slice, ndxFn, charset, bytes, <<char::binary, chars::binary>>)
  end

  ## -----------------------------------------------------------------------------------------------
  ##  validate_byte_count/3
  ## -----------------------------------------------------------------------------------------------
  @doc """
  Validate number of **_bytes_** is sufficient to generate random strings with entropy **_bits_**
  using **_charset_**

    - **_bits_** - entropy bits for random string
    - **_charset_** - characters in use
    - **_bytes_** - bytes to validate

  ### Validations

    - **_bytes_** count must be sufficient to generate entropy **_bits_** string from **_charset_**

  Use `EntropyString.CharSet.bytes_needed(bits, charset)` to determine how many **_bytes_** are
  needed
  """
  def validate_byte_count(bits, charset, bytes) when is_binary(bytes) do
    need = CharSet.bytes_needed(bits, charset)
    got = byte_size(bytes)

    case need <= got do
      true ->
        true

      _ ->
        reason = :io_lib.format("Insufficient bytes: need ~p and got ~p", [need, got])
        {:error, :binary.list_to_bin(reason)}
    end
  end

  ## -----------------------------------------------------------------------------------------------
  ##  ndx_fn/1
  ##  Return function to pull charset bits_per_char bits at position slice of bytes
  ## -----------------------------------------------------------------------------------------------
  defp ndx_fn(charset) do
    bitsPerChar = CharSet.bits_per_char(charset)

    fn slice, bytes ->
      offset = slice * bitsPerChar
      <<_skip::size(offset), ndx::size(bitsPerChar), _rest::bits>> = bytes
      ndx
    end
  end

  ## -----------------------------------------------------------------------------------------------
  ##  with_charset/1
  ##  For pre-defined CharSet, skip charset validation
  ## -----------------------------------------------------------------------------------------------
  defp with_charset(charset, doFn) do
    # Pre-defined charset does not require validation
    case is_predefined_charset(charset) do
      true ->
        doFn.()

      _ ->
        case CharSet.validate(charset) do
          true -> doFn.()
          error -> error
        end
    end
  end

  defp is_predefined_charset(:charset2), do: true
  defp is_predefined_charset(:charset4), do: true
  defp is_predefined_charset(:charset8), do: true
  defp is_predefined_charset(:charset16), do: true
  defp is_predefined_charset(:charset32), do: true
  defp is_predefined_charset(:charset64), do: true

  defp is_predefined_charset(charset) do
    charset == CharSet.charset64() or charset == CharSet.charset32() or
      charset == CharSet.charset16() or charset == CharSet.charset8() or
      charset == CharSet.charset4() or charset == CharSet.charset2()
  end

  ## -----------------------------------------------------------------------------------------------
  ##  Convert bits atom to bits integer
  ## -----------------------------------------------------------------------------------------------
  defp bits_from_atom(:small), do: 29
  defp bits_from_atom(:medium), do: 69
  defp bits_from_atom(:large), do: 99
  defp bits_from_atom(:session), do: 128
  defp bits_from_atom(:token), do: 256

  ## -----------------------------------------------------------------------------------------------
  ##  Convert charset atom to EntropyString.CharSet
  ## -----------------------------------------------------------------------------------------------
  defp charset_from_atom(:charset2), do: CharSet.charset2()
  defp charset_from_atom(:charset4), do: CharSet.charset4()
  defp charset_from_atom(:charset8), do: CharSet.charset8()
  defp charset_from_atom(:charset16), do: CharSet.charset16()
  defp charset_from_atom(:charset32), do: CharSet.charset32()
  defp charset_from_atom(:charset64), do: CharSet.charset64()
end
