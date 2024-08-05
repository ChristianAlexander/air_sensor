defmodule AirSensor.Poller do
  use GenServer

  @read_interval 30_000

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def latest do
    GenServer.call(__MODULE__, :get_latest_measurement)
  end

  @impl GenServer
  def init(_args) do
    {:ok, nil, {:continue, nil}}
  end

  @impl GenServer
  def handle_continue(nil, nil) do
    handle = AirSensor.Native.init()
    {:noreply, %{handle: handle}, {:continue, :read}}
  end

  @impl GenServer
  def handle_continue(:read, state) do
    Process.send_after(self(), :poll, @read_interval)

    {:noreply, read(state)}
  end

  @impl GenServer
  def handle_info(:poll, state) do
    Process.send_after(self(), :poll, @read_interval)

    {:noreply, read(state)}
  end

  @impl GenServer
  def handle_call(:get_latest_measurement, _from, state) do
    {:reply, state.latest_measurement, state}
  end

  defp read(%{handle: handle} = state) do
    latest_measurement = AirSensor.Native.read(handle)

    if latest_measurement != Map.get(state, :latest_measurement) do
      Phoenix.PubSub.broadcast(
        AirSensor.PubSub,
        "air_measurements",
        {:new_measurement, latest_measurement}
      )
    end

    Map.put(state, :latest_measurement, latest_measurement)
  end
end
