# Configless

Configless is an in memory configuration manager that persists to disk.

## Why?

Applications are not aware of configuration files except for reading them There are two methods of reading configuration files:

On demand: which has a performance impact

Reading and storing in memory on start: which desynchronizes the application from updates to the configuration without using a filsystem notifier

Writing is even worse, because of race conditions and the possibility of corrupting a flat text file.

Distributed options like Consul and Etcd are fantastic options for distributed systems, however such systems are overkill for a small stand alone application.

Having configuration completely in memory is sufficient for runtime usage, but is hard to configure from a systems configuration perspective, and is prone to data loss without being backed by an external storage solution.

Configless solves all of these problems by providing an in memory key value store that is backed by Mnesia. Every write is forced to disk, trading write performance for durability. Configuration writes are typically not a frequent operation.

## Note

For larger applications that are using an existing store backend, such as Postgres, it is suggested to leverage that backend instead. Configless is strictly for small applications that need an easy configuration pattern, and more specifically, to encourage good practice of handling application configurations.

This library will likely never be considered production ready, it serves as a pattern for handling application configuration as an alternative to flat config files.

## Installation

### Note, this package is not currently published

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `configless` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:configless, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/configless](https://hexdocs.pm/configless).

## Usage

Set a configuration value

```
Configless.set(:key, :value)
```

Set multiple configuration values using a map

```
Configless.set(%{key: :value, another: [0.1.2], nested: %{foo: :bar}})
```

Get a configuration value

```
Configless.get(:key) # > :value
```

## Setting values from external data

Configless does not make any assumptions about the source data, but a map can be provided to Configless.set/1 to set each key in the map to its corresponding value. An example use case would be to have an initialization function in the application that reads from an external JSON file, or receives a JSON request, and passes the parsed data to Configless.set/1.
