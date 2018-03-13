# EntropyString for Elixir

Efficiently generate cryptographically strong random strings of specified entropy from various character sets.

[![Build Status](https://travis-ci.org/EntropyString/Elixir.svg?branch=master)](https://travis-ci.org/EntropyString/Elixir) &nbsp; [![Hex Version](https://img.shields.io/hexpm/v/entropy_string.svg "Hex Version")](https://hex.pm/packages/entropy_string) &nbsp; [![License: MIT](https://img.shields.io/npm/l/express.svg)]()

### <a name="TOC"></a>TOC
 - [Installation](#Installation)
 - [Usage](#Usage)
 - [Overview](#Overview)
 - [Real Need](#RealNeed)
 - [Character Sets](#CharacterSets)
 - [Custom Characters](#CustomCharacters)
 - [Efficiency](#Efficiency)
 - [Custom Bytes](#CustomBytes)
 - [Entropy Bits](#EntropyBits)
 - [Take Away](#TakeAway)

### Installation

Add `entropy_string` to `mix.exs` dependencies:

  ```elixir
  def deps do
    [ {:entropy_string, "~> 1.0.0"} ]
  end
  ```

Update dependencies

  ```bash
  mix deps.get
  ```

[TOC](#TOC)

### <a name="Usage"></a>Usage

#### Examples

The `examples.exs` file contains a smattering of example uses:

  ```bash
  > iex --dot-iex iex.exs
  Erlang/OTP ...
  EntropyString Loaded

  Results of executing examples.exs file
  --------------------------------------

  Id: Predefined base 32 CharSet
    Characters: 2346789bdfghjmnpqrtBDFGHJLMNPQRT
    Session ID: L42P32Ldj6L8JdTTdt2HtHnp68

  Base64Id: Predefined URL and file system safe CharSet
    Characters: ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_
    Session ID: T9QCb6JqJKT4tTpIxXQjZQ

  HexId: Predefined hex CharSet
    Characters: 0123456789abcdef
    Small ID: 377831e9

  UpperHexId: Uppercase hex CharSet
    Characters: 0123456789ABCDEF
    Medium ID: EDC4C43949CC6D1D38

  DingoSky: Custom CharSet for a million IDs with a 1 in a billion chance of repeat
    Characters: dingosky
    DingoSky ID: yyynonysygngkysgydddgyn

  MyServer: 256 entropy bit token
    Characters: ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_
    MyServer Token: RtJosJEgOmA0oy8wPyUGju6SeJhCDJslTPUlVbRJgRM
  ```

The same IEx shell that runs the examples can be used to try `EntropyString`:

Generate a potential of _1 million_ random strings with _1 in a billion_ chance of repeat:

  ```elixir
  ES-iex> import EntropyString
  EntropyString
  ES-iex> bits(1.0e6, 1.0e9) |> random
  "GhrB6fJbD6gTpT"
  ```

`EntropyString` uses predefined `charset32` characters by default (reference [Character Sets](#CharacterSets)). To get a random hexadecimal string with the same entropy bits as above (see [Real Need](#RealNeed) for description of what entropy bits represents):

  ```elixir
  ES-iex> import EntropyString
  EntropyString
  ES-iex> bits(1.0e6, 1.0e9) |> random(:charset16)
  "acc071449951325cc5"
  ```

Custom characters may be specified. Using uppercase hexadecimal characters:

  ```elixir
  ES-iex> import EntropyString
  EntropyString
  ES-iex> bits(1.0e6, 1.0e9) |> random("0123456789ABCDEF")
  "E75C7A50972E4994ED"
  ```

Convenience functions exists for a variety of random string needs. For example, to create OWASP session ID using predefined base 32 characters:

  ```elixir
  ES-iex> EntropyString.session()
  "rp7D4hGp2QNPT2FP9q3rG8tt29"
  ```

Or a 256 bit token using [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5) file system and URL safe characters:

  ```elixir
  ES-iex> EntropyString.token()
  "X2AZRHuNN3mFUhsYzHSE_r2SeZJ_9uqdw-j9zvPqU2O"
  ```

#### Module `use`

The macro `use EntropyString` adds the following functions to a module: `small/1`, `medium/1`, `large/1`, `session/1`, `token/1`, `random/1`,  and `charset/0`. Without any options, the predefined `CharSet.charset32` is automatically used by all these functions except `token/1`, which uses `CharSet.charset64` by default.

  ```elixir
  ES-iex> defmodule Id, do: use EntropyString
  {:module, Id,
     ...
  ES-iex> Id.session()
  "69fB27R2TLNNr3bQNFbjTp399Q"
  ```

Generate a total of 30 potential strings with a 1 in a million chance of a repeat:

  ```elixir
  ES-iex> defmodule Id, do: use EntropyString
  {:module, Id,
     ...
  ES-iex> Id.small()
  "6jQTmD"
  ```

The default **_CharSet_** for a module can be specified by passing the `charset` option to the `use` macro:

  ```elixir
  ES-iex> defmodule HexId, do: use EntropyString, charset: :charset16
  {:module, HexId,
     ...
  ES-iex> HexId.session()
  "f54a61dd3018cbdb1c495a15b5e7f383"
  ```

Passing a `String` as the `charset` option specifies custom characters to use in the module:

  ```elixir
  ES-iex> defmodule DingoSky, do: use EntropyString, charset: "dingosky"
  {:module, DingoSky,
     ...
  ES-iex> DingoSky.medium()
  "dgoiokdooyykyisyyyoioks"
  ```

The function `charset` reveals the characters in use by the module:

  ```elixir
  ES-iex> defmodule Id, do: use EntropyString
  {:module, Id,
     ...
  ES-iex> Id.charset()
  "2346789bdfghjmnpqrtBDFGHJLMNPQRT"
  ```

Further investigations can use the modules defined in `examples.exs`:

  ```elixir
  ES-iex> Hex.medium()
  "e092b3e3e13704681f"
  ES-iex> DingoSky.id()
  "sngksyygyydgsknsdidysnd"
  ES-iex> WebServer.token()
  "mT2vN607xeJy8qzVElnFbCpCyYpuWrYRRKbtTsNI6RN"
  ```

[TOC](#TOC)

### <a name="Overview"></a>Overview

`EntropyString` provides easy creation of randomly generated strings of specific entropy using various character sets. Such strings are needed as unique identifiers when generating, for example, random IDs and you don't want the overkill of a GUID.

A key concern when generating such strings is that they be unique. Guaranteed uniqueness, however,, requires either deterministic generation (e.g., a counter) that is not random, or that each newly created random string be compared against all existing strings. When ramdoness is required, the overhead of storing and comparing strings is often too onerous and a different tack is chosen.

A common strategy is to replace the *guarantee of uniqueness* with a weaker but often sufficient *probabilistic uniqueness*. Specifically, rather than being absolutely sure of uniqueness, we settle for a statement such as *"there is less than a 1 in a billion chance that two of my strings are the same"*. This strategy requires much less overhead, but does require we have some manner of qualifying what we mean by *"there is less than a 1 in a billion chance that 1 million strings of this form will have a repeat"*.

Understanding probabilistic uniqueness of random strings requires an understanding of [*entropy*](https://en.wikipedia.org/wiki/Entropy_(information_theory)) and of estimating the probability of a [*collision*](https://en.wikipedia.org/wiki/Birthday_problem#Cast_as_a_collision_problem) (i.e., the probability that two strings in a set of randomly generated strings might be the same). The blog posting [Hash Collision Probabilities](http://preshing.com/20110504/hash-collision-probabilities/) provides an excellent overview of deriving an expression for calculating the probability of a collision in some number of hashes using a perfect hash with an N-bit output. The [Entropy Bits](#EntropyBits) section below discribes how `EntropyString` takes this idea a step further to address a common need in generating unique identifiers.

We'll begin investigating `EntropyString` and this common need by considering our [Real Need](#RealNeed) when generating random strings.

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

And the cat's out of the bag. We're getting at the real need, and it's not the same as the original statement. The developer needs *uniqueness* across some potential number of strings. The length of the string is a by-product of the uniqueness, not the goal, and should not be the primary specification for the random string.

As noted in the [Overview](#Overview), guaranteeing uniqueness is difficult, so we'll replace that declaration with one of *probabilistic uniqueness* by asking:

  - What risk of a repeat are you willing to accept?

Probabilistic uniqueness contains risk. That's the price we pay for giving up on the stronger declaration of strict uniqueness. But the developer can quantify an appropriate risk for a particular scenario with a statement like:

*I guess I can live with a 1 in a million chance of a repeat*.

So now we've gotten to the developer's real need:

*I need 10,000 random hexadecimal IDs with less than 1 in a million chance of any repeats*.

Not only is this statement more specific, there is no mention of string length. The developer needs probabilistic uniqueness, and strings are to be used to capture randomness for this purpose. As such, the length of the string is simply a by-product of the encoding used to represent the required uniqueness as a string.

How do you address this need using a library designed to generate strings of specified length?  Well, you don't directly, because that library was designed to answer the originally stated need, not the real need we've uncovered. We need a library that deals with probabilistic uniqueness of a total number of some strings. And that's exactly what `EntropyString` does.

Let's use `EntropyString` to help this developer generate 5 hexadecimal IDs from a pool of a potentail 10,000 IDs with a 1 in a milllion chance of a repeat:

  ```elixir
  ES-iex> import EntropyString
  EntropyString
  ES-iex> bits = bits(10000, 1.0e6)
  45.50699332842307
  ES-iex> for x <- :lists.seq(1,5), do: random(bits, :charset16)
  ["85e442fa0e83", "a74dc126af1e", "368cd13b1f6e", "81bf94e1278d", "fe7dec099ac9"]
  ```

Examining the above code,

  ```elixir
  bits = bits(10000, 1.0e6)
  ```

is used to determine how much entropy is needed to satisfy the probabilistic uniqueness of a **1 in a million** risk of repeat in a total of **10,000** strings. As you can see, we need about **45.51** bits of entropy. Then

  ```elixir
  random(bits, charset16)
  ```

is used to actually generate a random string of the specified entropy using hexadecimal characters. Looking at the IDs, we can see each is 12 characters long. Again, the string length is a by-product of the characters used to represent the entropy we needed. And it seems the developer didn't really need 16 characters after all.

Finally, given that the strings are 12 hexadecimals long, each string actually has an information carrying capacity of 12 * 4 = 48 bits of entropy (a hexadecimal character carries 4 bits). That's fine. Assuming all characters are equally probable, a string can only carry entropy equal to a multiple of the amount of entropy represented per character. `EntropyString` produces the smallest strings that *exceed* the specified entropy. So although we only really needed 45.51 bits of entropy to cover our specified probabilistic uniqueness, we actually got 48.

[TOC](#TOC)

### <a name="CharacterSets"></a>Character Sets

As we\'ve seen in the previous sections, `EntropyString` provides predefined characters for each of the supported character set lengths. Let\'s see what\'s under the hood. The predefined `CharSet`s are *charset64*, *charset32*, *charset16*, *charset8*, *charset4* and *charset2*. The characters for each were chosen as follows:

  - CharSet 64: **ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_**
      * The file system and URL safe char set from [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5).
      &nbsp;
  - CharSet 32: **2346789bdfghjmnpqrtBDFGHJLMNPQRT**
      * Remove all upper and lower case vowels (including y)
      * Remove all numbers that look like letters
      * Remove all letters that look like numbers
      * Remove all letters that have poor distinction between upper and lower case values.
      The resulting strings don't look like English words and are easy to parse visually.
      &nbsp;
  - CharSet 16: **0123456789abcdef**
      * Hexadecimal
      &nbsp;
  - CharSet  8: **01234567**
      * Octal
      &nbsp;
  - CharSet  4: **ATCG**
      * DNA alphabet. No good reason; just wanted to get away from the obvious.
      &nbsp;
  - CharSet  2: **01**
      * Binary

You may, of course, want to choose the characters used, which is covered next in [Custom Characters](#CustomCharacters).

[TOC](#TOC)

### <a name="CustomCharacters"></a>Custom Characters

Being able to easily generate random strings is great, but what if you want to specify your own characters? For example, suppose you want to visualize flipping a coin to produce 10 bits of entropy.

  ```elixir
  ES-iex> defmodule Coin do
  ...>   use EntropyString, charset: :charset2
  ...>   def flip(flips), do: Coin.random(flips)
  ...> end
  {:module, Coin,
     ...

  ES-iex> Coin.flip(10)
  "0100101011"
  ```

The resulting string of __0__'s and __1__'s doesn't look quite right. Perhaps you want to use the characters __H__ and __T__ instead.

  ```elixir
  ES-iex> defmodule Coin do
  ...>   use EntropyString, charset: "HT"
  ...>   def flip(flips), do: Coin.random(flips)
  ...> end
  {:module, Coin,
     ...

  ES-iex> Coin.flip(10)
  "HTTTHHTTHH"
  ```

As another example, we saw in [Character Sets](#CharacterSets) the predefined hex characters for `charSet16` are lowercase. Suppose you like uppercase hexadecimal letters instead.

  ```elixir
  ES-iex> defmodule HexString, do: use EntropyString, charset: "0123456789ABCDEF"
  {:module, HexString,
     ...
  ES-iex> HexString.random(:medium)
  "C63CE7FE655C89B8BE"
  ```

A `:medium` entropy string represents 1 in a billion chance of repeat for a strings.

To facilitate [efficient](#Efficiency) generation of strings, `EntropyString` limits character set lengths to powers of 2. Attempting to use a character set of an invalid length returns an error.

  ```elixir
  ES-iex> import EntropyString
  EntropyString
  ES-iex> EntropyString.random(:medium, "123456789ABCDEF")
  {:error, "Invalid char count: must be one of 2,4,8,16,32,64"}
  ```

Likewise, since calculating entropy requires specification of the probability of each symbol, `EntropyString` requires all characters in a set be unique. (This maximize entropy per string as well).

  ```elixir
  ES-iex> import EntropyString
  EntropyString
  ES-iex> EntropyString.random(:medium, "123456789ABCDEF1")
  {:error, "Chars not unique"}
  ```

[TOC](#TOC)

### <a name="Efficiency"></a>Efficiency

To efficiently create random strings, `EntropyString` generates the necessary number of random bytes needed for each string and uses those bytes in a binary pattern matching scheme to index into a character set. For example, to generate strings from the __32__ characters in the *charSet32* character set, each index needs to be an integer in the range `[0,31]`. Generating a random string of *charSet32* characters is thus reduced to generating random indices in the range `[0,31]`.

To generate the indices, `EntropyString` slices just enough bits from the random bytes to create each index. In the example at hand, 5 bits are needed to create an index in the range `[0,31]`. `EntropyString` processes the random bytes 5 bits at a time to create the indices. The first index comes from the first 5 bits of the first byte, the second index comes from the last 3 bits of the first byte combined with the first 2 bits of the second byte, and so on as the bytes are systematically sliced to form indices into the character set. And since binary pattern matching is really efficient, this scheme is quite fast.

The `EntropyString` scheme is also efficient with regard to the amount of randomness used. Consider the following possible Elixir solution to generating random strings. To generated a character, an index into the available characters is created using `Enum.random`. The code looks something like:

  ```elixir
  ES-iex> defmodule MyString do
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
  {:module, MyString,
     ...
  ES-iex> MyString.random_string 16
  "j0jaxxnoipdgksxi"
  ```

In the code above, `Enum.random` generates a value used to index into the hexadecimal character set. The Elixir docs for `Enum.random` indicate it uses the Erlang `rand` module, which in turn indicates that each random value has 58 bits of precision. Suppose we're creating strings with **len = 16**. Generating each string character consumes 58 bits of randomness while only injecting 5 bits (`log2(32)`) of entropy into the resulting random string. The resulting string has an information carrying capacity of 16 * 5 = 80 bits, so creating each string requires a *total* of 928 bits of randomness while only actually *carrying* 80 bits of that entropy forward in the string itself. That means 848 bits (91%) of the generated randomness is simply wasted.

Compare that to the `EntropyString` scheme. For the example above, plucking 5 bits at a time requires a total of 80 bits (10 bytes) be available. Creating the same strings as above, `EntropyString` uses 80 bits of randomness per string with no wasted bits. In general, the `EntropyString` scheme can waste up to 7 bits per string, but that's the worst case scenario and that's *per string*, not *per character*!

There is, however, a potentially bigger issue at play in the above code. Erlang `rand`, and therefor Elixir `Enum.random`, does not use a cryptographically strong psuedo random number generator. So the above code should not be used for session IDs or any other purpose that requires secure properties.

There are certainly other popular ways to create random strings, including secure ones. For example, generating secure random hex strings can be done by

  ```elixir
  ES-iex> Base.encode16(:crypto.strong_rand_bytes(8))
  "389B363BB7FD6227"
  ```

Or, to generate file system and URL safe strings

  ```elixir
  ES-iex> Base.url_encode64(:crypto.strong_rand_bytes(8))
  "5PLujtDieyA="
  ```

Since Base64 encoding is concerned with decoding as well, you would have to strip any padding characters. That's the price we pay for using a function for something it wasn't designed for.

These two solutions each have limitations. You can't alter the characters, but more importantly, each lacks a clear specification of how random the resulting strings actually are. Each specifies a number of bytes as opposed to specifying the entropy bits sufficient to represent some total number of strings with an explicit declaration of an associated risk of repeat using whatever encoding characters you want. That's a bit of a mouthful, but the important point is with `EntropyString` you _explicitly_ declare your intent.

Fortunately you don't need to really understand how secure random bytes are efficiently sliced and diced to use `EntropyString`. But you may want to provide your own [Custom Bytes](#CustomBytes), which is the next topic.

[TOC](#TOC)

### <a name="CustomBytes"></a>Custom Bytes

As previously described, `EntropyString` automatically generates cryptographically strong random bytes to generate strings. You may, however, have a need to provide your own bytes, for deterministic testing or perhaps to use a specialized random byte generator.

Suppose we want 30 strings with no more than a 1 in a million chance of repeat while using 32 characters. We can specify the bytes to use during string generation by

  ```elixir
  ES-iex> bytes = <<0xfa, 0xc8, 0x96, 0x64>>
  <<250, 200, 150, 100>>
  ES-iex> EntropyString.random(:small, :charset32, bytes)
  "Th7fjL"
  ```

The __bytes__ provided can come from any source. However, an error is returned if the number of bytes is insufficient to generate the string as described in the [Efficiency](#Efficiency) section:

  ```elixir
  ES-iex> bytes = <<0xfa, 0xc8, 0x96, 0x64>>
  <<250, 200, 150, 100>>
  ES-iex> EntropyString.random(:large, :charset32, bytes )
  {:error, "Insufficient bytes: need 14 and got 4"}
  ```

`EntropyString.CharSet.bytes_needed/2` can be used to determine the number of bytes needed to cover a specified amount of entropy for a given character set.

  ```elixir
  EX-iex> EntropyString.CharSet.bytes_needed(:large, :charset32)
  13
  ```

[TOC](#TOC)

### <a name="EntropyBits"></a>Entropy Bits

Thus far we've avoided the mathematics behind the calculation of the entropy bits required to specify a risk that some number random strings will not have a repeat. As noted in the [Overview](#Overview), the posting [Hash Collision Probabilities](http://preshing.com/20110504/hash-collision-probabilities/) derives an expression, based on the well-known [Birthday Problem](https://en.wikipedia.org/wiki/Birthday_problem#Approximations), for calculating the probability of a collision in some number of hashes (denoted by `k`) using a perfect hash with an output of `M` bits:

![Hash Collision Probability](images/HashCollision.png)

There are two slight tweaks to this equation as compared to the one in the referenced posting. `M` is used for the total number of possible hashes and an equation is formed by explicitly specifying that the expression in the posting is approximately equal to `1/n`.

More importantly, the above equation isn't in a form conducive to our entropy string needs. The equation was derived for a set number of possible hashes and yields a probability, which is fine for hash collisions but isn't quite right for calculating the bits of entropy needed for our random strings.

The first thing we'll change is to use `M = 2^N`, where `N` is the number of entropy bits. This simply states that the number of possible strings is equal to the number of possible values using `N` bits:

![N-Bit Collision Probability](images/NBitCollision.png)

Now we massage the equation to represent `N` as a function of `k` and `n`:

![Entropy Bits Equation](images/EntropyBits.png)

The final line represents the number of entropy bits `N` as a function of the number of potential strings `k` and the risk of repeat of 1 in `n`, exactly what we want. Furthermore, the equation is in a form that avoids really large numbers in calculating `N` since we immediately take a logarithm of each large value `k` and `n`.

[TOC](#TOC)

### <a name="TakeAway"></a>Take Away

  - You don't need random strings of length L
    - String length is a by-product, not a goal
  - You don't need truly unique strings
    - Uniqueness is too onerous. You'll do fine with probabilistically unique strings.
  - Probabilistic uniqueness involves measured risk
    - Risk is measured in terms of collision, as *"1 in __n__ chance of generating a repeat"*
  - You need to a total of **_N_** strings with a risk **_1/n_** of repeat
    - The characters are arbitrary
  - You want to be explicit in terms of your real need
    - You need `EntropyString`.

##### A million potential IDs with a 1 in a trillion chance of a repeat:

  ```elixir
  ES-iex> defmodule MyId do
  ...>   use EntropyString
  ...>   @bits EntropyString.bits(1.0e6, 1.0e12)
  ...>   def create, do: EntropyString.random(@bits)
  ...> end
  {:module, MyId,
     ...
  ES-iex> MyId.create()
  "Dn8nhmL9TpDTPBrmH43mHMmbDg"
  ```

##### Server Session IDs

  ```elixir
  ES-iex> defmodule ServerId, do: use EntropyString
  {:module, ServerId,
     ...
  ES-iex> ServerId.session()
  "j48RGdJd6RgHF3N8b98h3NLnnQ"
  ```

##### Hex Session IDs

  ```elixir
  ES-iex> defmodule SessionId do
  ...>   use EntropyString, charset: :charset16
  ...>   def create, do: EntropyString.session()
  ...>   end
  {:module, SessionId,
     ...
  ES-iex> SessionId.create()
  "eda5e254d24d71304f6a41fb10c3102d"
  ```



[TOC](#TOC)
