defmodule Catcher.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Catcher.Repo,
      # Start the Telemetry supervisor
      CatcherWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Catcher.PubSub},
      # Start the Endpoint (http/https)
      CatcherWeb.Endpoint,
      # Start a worker by calling: Catcher.Worker.start_link(arg)
      # {Catcher.Worker, arg}

      # Database Garbage Collector
      Catcher.DatabaseGarbageCollector
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Catcher.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CatcherWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
