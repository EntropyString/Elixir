defmodule EntropyString.Mixfile do
  use Mix.Project

  def project do
    [
      app: :entropy_string,
      version: "1.3.3",
      elixir: "~> 1.8",
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  defp deps,
    do: [
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev}
    ]

  defp description do
    """
    Efficiently generate cryptographically strong random strings of specified entropy from various character sets. `EntropyString` is superseded by `Puid` (https://hex.pm/packages/puid).
    """
  end

  defp package do
    [
      maintainers: ["Paul Rogers"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/EntropyString/Elixir"}
    ]
  end
end
