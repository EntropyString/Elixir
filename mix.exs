defmodule EntropyString.Mixfile do
  use Mix.Project

  def project do
    [ app: :entropy_string,
      version: "1.0.2",
      elixir: "~> 1.4",
      deps: deps(),

      description: description(),
      package: package()
    ]
  end

  defp deps do
    [{:earmark, "~> 1.0", only: :dev},
     {:ex_doc, "~> 0.16", only: :dev}
    ]
  end

  defp description do
    """
Efficiently generate cryptographically strong random strings of specified entropy from various character sets.
    """
  end

  defp package do
    [maintainers: ["Paul Rogers"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/EntropyString/Elixir" }]
  end    
end
