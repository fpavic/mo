defmodule Mo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      MoWeb.Telemetry,
      {Phoenix.PubSub, name: Mo.PubSub},
      MoWeb.Endpoint,
      Mo.GameSupervisor
    ]

    opts = [strategy: :one_for_one, name: Mo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
