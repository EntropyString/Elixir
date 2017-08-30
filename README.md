# EntropyString for Elixir

Efficiently generate cryptographically strong random strings of specified entropy from various character sets.

[![Build Status](https://travis-ci.org/EntropyString/Elixir.svg?branch=master)](https://travis-ci.org/EntropyString/Elixir) &nbsp; [![Hex Version](https://img.shields.io/hexpm/v/entropy_string.svg "Hex Version")](https://hex.pm/packages/entropy_string) &nbsp; [![License: MIT](https://img.shields.io/npm/l/express.svg)]()

https://github.com/EntropyString/EntropyString-Swift/blob/master/LICENSE

### <a name="TOC"></a>TOC
 - [Installation](#Installation)
 - [Usage](#Usage)
 - [Overview](#Overview)
 - [Real Need](#RealNeed)
 - [Character Sets](#CharacterSets)
 - [Custom Characters](#CustomCharacters)
 - [Efficiency](#Efficiency)
 - [Custom Bytes](#CustomBytes)
 - [Take Away](#TakeAway)

### Installation

#### Hex

Install via [Hex](https://hex.pm/docs/publish) by adding `entropy_string` in `mix.exs`:

  ```elixir
  def deps do
    [ {:entropy_string, "~> 0.1.0"} ]
  end
  ```

[TOC](#TOC)

### <a name="Usage"></a>Usage

OWASP session ID using predefined base 32 characters:

  ```elixir
  iex> import EntropyString.CharSet, only: [charset32: 0]
  iex> EntropyString.session_id(charset32)
  ```

  > "rp7D4hGp2QNPT2FP9q3rG8tt29"

Session ID using [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5) file system and URL safe characters:

  ```elixir
  iex> import EntropyString.CharSet, only: [charset64: 0]
  iex> EntropyString.session_id(charset64)
  ```

  > "wpi3-HElCowpZbIjdNNjpz"

Generate a potential of _1 million_ random strings with _1 in a billion_ chance of repeat:

  ```elixir
  iex> import EntropyString
  iex> entropy_bits(ten_p(6), ten_p(9)) |> random_string
  ```

  > "GhrB6fJbD6gTpT"

**_EntropyString_** uses predefined `charset32` characters by default (reference [Character Sets](#CharacterSets)). To get a random hexadecimal string with the same entropy `bits` as above (i.e., same total number of potential strings with the specified risk):

  ```elixir
  iex> import EntropyString
  iex> import EntropyString.CharSet, only: [charset16: 0]
  iex> entropy_bits(ten_p(6), ten_p(9)) |> random_string(charset16)
  ```

  > "acc071449951325cc5"

Custom characters may be specified. Using uppercase hexadecimal characters:

  ```elixir
  iex> import EntropyString
  iex> import EntropyString.CharSet, only: [charset16: 0]
  iex> entropy_bits(ten_p(6), ten_p(9)) |> random_string(String.upcase(charset16))
  ```

  > "E75C7A50972E4994ED"

#### Module `use`

The macro `use EntropyString` adds the following functions to a module: `small_id/1`, `medium_id/1`, `large_id/1`, `session_id/1`, `token/1`, `random_string/2`,  and `charset/0`. Without any options, the predefined `CharSet.charset32` is automatically used by all these functions except `token/2`, which uses `CharSet.charset64` by default.

  ```elixir
  iex> defmodule Id, do: use EntropyString
  iex> Id.session_id
  ```

  > "69fB27R2TLNNr3bQNFbjTp399Q"

Generate a total of 30 potential strings with a 1 in a million chance of a repeat:

  ```elixir
  iex> Id.small_id
  ```

  > "6jQTmD"

The default **_CharSet_** for a module can be specified by passing the `charset` option to the `use` macro:

  ```elixir
  iex> defmodule HexId, do: use EntropyString, charset: EntropyString.CharSet.charset16
  iex> HexId.session_id
  ```

  > "f54a61dd3018cbdb1c495a15b5e7f383"

Passing a `String` as the `charset` option specifies custom characters to use in the module:

  ```elixir
  iex> defmodule DingoSky, do: use EntropyString, charset: "dingosky"
  iex> DingoSky.medium_id
  ```

  > "dgoiokdooyykyisyyyoioks"

The funtion `charset` reveals the characters in use by the module:

  ```elixir
  iex> defmodule Id, do: use EntropyString
  iex> Id.charset
  ```

  > "2346789bdfghjmnpqrtBDFGHJLMNPQRT"

#### Examples

To run the examples in the `examples.exs` file, first compile `EntropyString`

  ```bash
  > mix compile
  ```

and then launch the Elixir shell from the project base directory

  ```bash
  > iex
  ```

The customizations in `.iex.exs` automatically load `EntropyString` and run `examples.exs`.

  ```elixir
  ES-iex> HexId.medium_id
  ```
  
  > "e092b3e3e13704681f"

  ```elixir
  ES-iex> DingoSky.id
  ```
  
  > "sngksyygyydgsknsdidysnd"

  ```elixir
  ES-iex> MyServer.token
  ```
  
  > "mT2vN607xeJy8qzVElnFbCpCyYpuWrYRRKbtTsNI6RN"

[TOC](#TOC)

### <a name="Overview"></a>Overview

`EntropyString` provides easy creation of randomly generated strings of specific entropy using various character sets. Such strings are needed when generating, for example, random IDs and you don't want the overkill of a GUID, or for ensuring that some number of items have unique identifiers.

A key concern when generating such strings is that they be unique. To truly guarantee uniqueness requires either deterministic generation (e.g., a counter) that is not random, or that each newly created random string be compared against all existing strings. When ramdoness is required, the overhead of storing and comparing all strings is often too onerous and a different tack is needed.

A common strategy is to replace the *guarantee of uniqueness* with a weaker but often sufficient *probabilistic uniqueness*. Specifically, rather than being absolutely sure of uniqueness, we settle for a statement such as *"there is less than a 1 in a billion chance that two of my strings are the same"*. This strategy requires much less overhead, but does require we have some manner of qualifying what we mean by, for example, *"there is less than a 1 in a billion chance that 1 million strings of this form will have a repeat"*.

Understanding probabilistic uniqueness requires some understanding of [*entropy*](https://en.wikipedia.org/wiki/Entropy_(information_theory)) and of estimating the probability of a [*collision*](https://en.wikipedia.org/wiki/Birthday_problem#Cast_as_a_collision_problem) (i.e., the probability that two strings in a set of randomly generated strings might be the same).  Happily, you can use `EntropyString` without a deep understanding of these topics.

We'll begin investigating `EntropyString` by considering our [Real Need](Read%20Need) when generating random strings.

[TOC](#TOC)

### <a name="RealNeed"></a>Real Need

Let's start by reflecting on a common statement of need for developers, who might say:

*I need random strings 16 characters long.*

Okay. There are libraries available that address that exact need. But first, there are some questions that arise from the need as stated, such as:

  1. What characters do you want to use?
  2. How many of these strings do you need?
  3. Why do you need these strings?

The available libraries often let you specify the characters to use. So we can assume for now that question 1 is answered with:

*Hexadecimal will do fine*.

As for question 2, the developer might respond:

*I need 10,000 of these things*.

Ah, now we're getting somewhere. The answer to question 3 might lead to the further qualification:

*I need to generate 10,000 random, unique IDs*.

And the cat's out of the bag. We're getting at the real need, and it's not the same as the original statement. The developer needs *uniqueness* across a potentail total of some number of strings. The length of the string is a by-product of the uniqueness, not the goal.

As noted in the [Overview](#Overview), guaranteeing uniqueness is difficult, so we'll replace that declaration with one of *probabilistic uniqueness* by asking:

  - What risk of a repeat are you willing to accept?

Probabilistic uniqueness contains risk. That's the price we pay for giving up on the stronger declaration of strict uniqueness. But the developer can quantify an appropriate risk for a particular scenario with a statement like:

*I guess I can live with a 1 in a million chance of a repeat*.

So now we've gotten to the developer's real need:

*I need 10,000 random hexadecimal IDs with less than 1 in a million chance of any repeats*.

Not only is this statement more specific, there is no mention of string length. The developer needs probabilistic uniqueness, and strings are to be used to capture randomness for this purpose. As such, the length of the string is simply a by-product of the encoding used to represent the required uniqueness as a string.

How do you address this need using a library designed to generate strings of specified length?  Well, you don't directly, because that library was designed to answer the originally stated need, not the real need we've uncovered. We need a library that deals with probabilistic uniqueness of a total number of some strings. And that's exactly what `EntropyString` does.

Let's use `EntropyString` to help this developer by generating 5 IDs:

  ```elixir
  iex> import EntropyString
  iex> import EntropyString.CharSet, only: [charset16: 0]
  iex> bits = entropy_bits(10000, 1000000)
  iex> strings = for x <- :lists.seq(1,5), do: random_string(bits, charset16)
  iex> IO.inspect strings
  ```

  > Strings: ["85e442fa0e83", "a74dc126af1e", "368cd13b1f6e", "81bf94e1278d", "fe7dec099ac9"]

To generate the IDs, we first use

  ```elixir
  bits = entropy_bits(10000, 1000000)
  ```

to determine how much entropy is needed to generate a potential of _10000 strings_ while satisfy the probabilistic uniqueness of a _1 in a million risk_ of repeat.. We didn't print the result, but if you did you'd see it's about **45.51** bits. Then inside the list comprehension we used

  ```elixir
  random_string(bits, charset16)
  ```

to actually generate a random string of the specified entropy using hexadecimal (charSet16) characters. Looking at the IDs, we can see each is 12 characters long. Again, the string length is a by-product of the characters used to represent the entropy we needed. And it seems the developer didn't really need 16 characters after all.

Finally, given that the strings are 12 hexadecimals long, each string actually has an information carrying capacity of 12 * 4 = 48 bits of entropy (a hexadecimal character carries 4 bits). That's fine. Assuming all characters are equally probable, a string can only carry entropy equal to a multiple of the amount of entropy represented per character. `EntropyString` produces the smallest strings that *exceed* the specified entropy.

[TOC](#TOC)

### <a name="CharacterSets"></a>Character Sets

As we\'ve seen in the previous sections, `EntropyString` provides predefined characters for each of the supported character set lengths. Let\'s see what\'s under the hood. The predefined `CharSet`s are *charset64*, *charset32*, *charset16*, *charset8*, *charset4* and *charset2*. The characters for each were chosen as follows:

  - CharSet 64: **ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_**
      * The file system and URL safe char set from [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5).
  - CharSet 32: **2346789bdfghjmnpqrtBDFGHJLMNPQRT**
      * Remove all upper and lower case vowels (including y)
      * Remove all numbers that look like letters
      * Remove all letters that look like numbers
      * Remove all letters that have poor distinction between upper and lower case values.
      The resulting strings don't look like English words and are easy to parse visually.

  - CharSet 16: **0123456789abcdef**
      * Hexadecimal
  - CharSet  8: **01234567**
      * Octal
  - CharSet  4: **ATCG**
      * DNA alphabet. No good reason; just wanted to get away from the obvious.
  - CharSet  2: **01**
      * Binary

You may, of course, want to choose the characters used, which is covered next in [Custom Characters](#CustomCharacters).

[TOC](#TOC)

### <a name="CustomCharacters"></a>Custom Characters

Being able to easily generate random strings is great, but what if you want to specify your own characters? For example, suppose you want to visualize flipping a coin to produce 10 bits of entropy.

  ```elixir
  iex> defmodule Coin do
  ...>   use EntropyString, charset: EntropyString.CharSet.charset2
  ...>   def flip(flips), do: Coin.random_string(flips)
  ...> end
  
  iex> flips = Coin.flip(10)
  iex> IO.puts "Flips: #{flips}"
  ```

  > flips: 0100101011

The resulting string of __0__'s and __1__'s doesn't look quite right. Perhaps you want to use the characters __H__ and __T__ instead.

  ```elixir
  iex> defmodule Coin do
  ...>   use EntropyString, charset: "HT"
  ...>   def flip(flips), do: Coin.random_string(flips)
  ...> end
  
  iex> flips = Coin.flip(10)
  iex> IO.puts "Flips: #{flips}"
  ```

  > flips: HTTTHHTTHH

As another example, we saw in [Character Sets](#CharacterSets) the predefined characters for `charSet16` are **0123456789abcdef**. Suppose you like uppercase hexadecimal letters instead.

  ```elixir
  iex> defmodule HexString, do: use EntropyString, charset: "0123456789ABCDEF"
  iex> HexString.random_string(48)
  ```

  > 3BD881733687

[TOC](#TOC)

### <a name="Efficiency"></a>Efficiency

To efficiently create random strings, `EntropyString` generates the necessary number of random bytes needed for each string and uses those bytes in a binary pattern matching scheme to index into a character set. For example, to generate strings from the __32__ characters in the *charSet32* character set, each index needs to be an integer in the range `[0,31]`. Generating a random string of *charSet32* characters is thus reduced to generating random indices in the range `[0,31]`.

To generate the indices, `EntropyString` slices just enough bits from the random bytes to create each index. In the example at hand, 5 bits are needed to create an index in the range `[0,31]`. `EntropyString` processes the random bytes 5 bits at a time to create the indices. The first index comes from the first 5 bits of the first byte, the second index comes from the last 3 bits of the first byte combined with the first 2 bits of the second byte, and so on as the bytes are systematically sliced to form indices into the character set. And since binary pattern matching is really efficient, this scheme is quite fast.

The `EntropyString` scheme is also efficient with regard to the amount of randomness used. Consider the following possible Elixir solution to generating random strings. To generated a character, an index into the available characters is created using `Enum.random`. The code looks something like:

  ```elixir
  iex> defmodule MyString do
  ...>   @chars "abcdefghijklmnopqrstuvwxyz0123456"
  ...>   @max String.length(@chars)-1
  ...>
  ...>   defp random_char do
  ...>     ndx = Enum.random 0..@max
  ...>     String.slice @chars, ndx..ndx
  ...>   end
  ...>
  ...>   def random_string(len) do
  ...>     list = for _ <- :lists.seq(1,len), do: random_char
  ...>     List.foldl(list, "", fn(e,acc) -> acc <> e end)
  ...>   end
  ...> end
  
  iex> MyString.random_string 16
  ```
  
  > "j0jaxxnoipdgksxi"

In the code above, `Enum.random` generates a value used to index into the hexadecimal character set. The Elixir docs for `Enum.random` indicate it uses the Erlang `rand` module, which in turn indicates that each random value has 58 bits of precision. Suppose we're creating strings with **len=16**. Then each string character consumes 58 bits of randomness while only injecting 5 bits (`log2(32)`) of entropy into the resulting random string. The resulting string has an information carrying capacity of 16 * 5 = 80 bits, so creating each string requires a *total* of 928 bits of randomness while only actually *carrying* 80 bits of that entropy forward in the string itself. That means 848 bits (91%) of the generated randomness is simply wasted.

Compare that to the `EntropyString` scheme. For the example above, plucking 5 bits at a time requires a total of 80 bits (10 bytes). Creating the same strings as above, `EntropyString` uses 80 bits of randomness per string with no wasted bits. In general, the `EntropyString` scheme can waste up to 7 bits per string, but that's the worst case scenario and that's *per string*, not *per character*!

There is, however, a potentially bigger issue at play in the above code. Erlang `rand`, and therefor Elixir `Enum.random`, is not a cryptographically strong psuedo random number generator. So the above code should not be used for session IDs or any other purpose that requires secure properties.

There are certainly other popular ways to create random strings, including secure ones. For example, generating secure random hex strings can be done by

  ```elixir
  Base.encode16(:crypto.strong_rand_bytes(8))
  ```

  > "389B363BB7FD6227"

Or, to generate file system and URL safe strings

  ```elixir
  Base.url_encode64(:crypto.strong_rand_bytes(8))
  ```
  
  > "5PLujtDieyA="

You would, of course, want to strip any padding characters.

These two solution, however, each have the same limitations. You can't alter the characters, but more importantly, each is focused on a wrong aspect of specification, i.e., specifying string length as opposed to specifying the entropy bits sufficient to represent some total number of strings with an explicit declaration of an associated risk of repeat. As discussed in [Real Need](#RealNeed), string length is a by-product, not a goal.

Fortunately you don't need to really understand how secure random bytes are efficiently sliced and diced to generate **_EntropyString_** random strings. But you may want to provide your own [Custom Bytes](#CustomBytes), which is the next topic.

[TOC](#TOC)

### <a name="CustomBytes"></a>Custom Bytes

As previously described, `EntropyString` automatically generates cryptographically strong random bytes to generate strings.  You may, however, have a need to provide your own bytes, for deterministic testing or perhaps to use a specialized random byte generator.

Suppose we want a string capable of 30 bits of entropy using 32 characters. We can specify the 4 bytes to use by:

  ```elixir
  iex> import EntropyString.CharSet, only: [charset32: 0]
  iex> bytes = <<0xfa, 0xc8, 0x96, 0x64>>
  iex> EntropyString.random_string(30, charset32, bytes )
  ```

  > "Th7fjL"
 
The __bytes__ provided can come from any source. However, an error is returned if the number of bytes is insufficient to generate the string as described in the [Efficiency](#Efficiency) section:

  ```elixir
  iex> import EntropyString.CharSet, only: [charset32: 0]
  iex> bytes = <<0xfa, 0xc8, 0x96, 0x64>>
  iex> EntropyString.random_string(32, charset32, bytes )
  ```

  > {:error, "Insufficient bytes: need 5 and got 4"}

Note the number of bytes needed is dependent on the number of characters in the **_CharSet_**. For a string representation of entropy, we can only have multiples of the bits of entropy per character used. So in the example above, to get at least 32 bits of entropy using a character set of 32 characters (5 bits per char), we'll need enough bytes to cover 35 bits, not 32, and an appropriate error is returned.

[TOC](#TOC)

### <a name="TakeAway"></a>Take Away

  - You don't need random strings of length L.
    - String length is a by-product, not a goal.
  - You don't need truly unique strings.
    - Uniqueness is too onerous. You'll do fine with probabilistically unique strings.
  - Probabilistic uniqueness involves measured risk.
    - Risk is measured as *"1 in __n__ chance of generating a repeat"*
    - Bits of entropy gives you that measure.
  - You need to a total of **_N_** strings with a risk **_1/n_** of repeat.
    - The characters are arbitrary.
  - You need `EntropyString`.
  
##### One million IDs with a 1 in a billion chance of a repeat:

  ```elixir
  iex> defmodule Id do
  ...>   use EntropyString
  ...>
  ...>   @bits entropy_bits(ten_p(6), ten_p(9))
  ...>
  ...>   def random, do: Id.random_string(@bits)
  ...> end
  
  iex> Id.random
  ```
  
  > "MP6qn86dHbBjD4"
  
[TOC](#TOC)
