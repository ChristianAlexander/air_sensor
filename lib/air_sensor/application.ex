defmodule AirSensor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AirSensorWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:air_sensor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AirSensor.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AirSensor.Finch},
      AirSensor.Poller,
      # Start a worker by calling: AirSensor.Worker.start_link(arg)
      # {AirSensor.Worker, arg},
      # Start to serve requests, typically the last entry
      AirSensorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AirSensor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AirSensorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
