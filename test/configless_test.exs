defmodule ConfiglessTest do
  use ExUnit.Case
  doctest Configless

  test "sets and gets a value" do
    :ok = Configless.set(:foo, :bar)
    assert Configless.get(:foo) == :bar
  end

  test "sets and gets from a map" do
    :ok = Configless.set(%{string: "string", map: %{key: "val"}, list: [0, 1, 2]})
    assert Configless.get(:string) == "string"
    assert Configless.get(:map) == %{key: "val"}
    assert Configless.get(:list) == [0, 1, 2]
  end
end
