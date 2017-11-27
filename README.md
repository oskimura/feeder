# Feeder

Feeder is RSS Feeder.
scrape RSS.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `feeder` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:feeder, "~> 0.1.0"}]
    end
    ```

  2. Ensure `feeder` is started before your application:

    ```elixir
    def application do
      [applications: [:feeder]]
    end
    ```

## Compile

Buid escript

```
mix escript.build
```

## fun

run feeder escript 

```
./feeder
```
