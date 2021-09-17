defmodule Configless.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Configless.start()

    Supervisor.start_link([], strategy: :one_for_one)
  end
end
