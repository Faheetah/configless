defmodule Configless do
  @moduledoc """
  Configless is an in memory configuration manager that persists to disk.
  """

  alias :mnesia, as: Mnesia

  @doc "Start and configure Mnesia"
  def start() do
    with :ok <- create_schema(),
         :ok <- Mnesia.start(),
         :ok <- create_table() do
      :ok
    else
      err -> throw(err)
    end
  end

  @doc "Get a key by name"
  def get(key) do
    case Mnesia.transaction(fn -> Mnesia.read({Configless, key}) end) do
      {:atomic, [{Configless, ^key, val}]} -> val
      {:atomic, []} -> nil
      unknown -> throw("Could not get config item: #{inspect(unknown)}")
    end
  end

  @doc "Set a key with the given value"
  def set(key, value) do
    Mnesia.sync_transaction(fn ->
      :ok = Mnesia.write({Configless, key, value})
    end)

    Mnesia.sync_log()
  end

  @doc """
  Set multiple keys from a map, where each map key will be the configuration
  key and the value is the value of the map
  """
  def set(config) when is_map(config) do
    Enum.each(config, fn {key, val} -> set(key, val) end)
  end

  defp create_schema() do
    case Mnesia.create_schema([Node.self()]) do
      {:error, {_, {:already_exists, _}}} -> :ok
      :ok -> :ok
      error -> error
    end
  end

  defp create_table() do
    case Mnesia.create_table(Configless, attributes: [:key, :value], disc_copies: [Node.self()]) do
      {:atomic, :ok} -> :ok
      {:aborted, {:already_exists, Configless}} -> :ok
      error -> error
    end
  end
end
