defmodule AirSensorWeb.SensorLive do
  use AirSensorWeb, :live_view

  def mount(_params, _session, socket) do
    measurement = AirSensor.Poller.latest

    if connected?(socket), do: Phoenix.PubSub.subscribe(AirSensor.PubSub, "air_measurements")

    {:ok, assign(socket, measurement: measurement)}
  end

  def handle_info({:new_measurement, measurement}, socket) do
    {:noreply, assign(socket, measurement: measurement)}
  end

  def render(assigns) do
    ~H"""
    <dl class="mx-auto grid grid-cols-1 gap-px bg-gray-900/5 sm:grid-cols-2 lg:grid-cols-4">
      <div class="flex flex-wrap items-baseline justify-between gap-x-4 gap-y-2 bg-white px-4 py-10 sm:px-6 xl:px-8">
        <dt class="text-sm font-medium leading-6 text-gray-500">Temperature</dt>
        <dd class="w-full flex-none text-3xl font-medium leading-10 tracking-tight text-gray-900 text-nowrap"><%= Float.round(@measurement.temperature, 2) %>℉</dd>
      </div>
      <div class="flex flex-wrap items-baseline justify-between gap-x-4 gap-y-2 bg-white px-4 py-10 sm:px-6 xl:px-8">
        <dt class="text-sm font-medium leading-6 text-gray-500">CO<sub>2</sub> Level</dt>
        <dd class="w-full flex-none text-3xl font-medium leading-10 tracking-tight text-gray-900 text-nowrap"><%= @measurement.co2_level %> ppm</dd>
      </div>
      <div class="flex flex-wrap items-baseline justify-between gap-x-4 gap-y-2 bg-white px-4 py-10 sm:px-6 xl:px-8">
        <dt class="text-sm font-medium leading-6 text-gray-500">Pressure</dt>
        <dd class="w-full flex-none text-3xl font-medium leading-10 tracking-tight text-gray-900 text-nowrap"><%= Float.round(@measurement.pressure, 2) %> hPa</dd>
      </div>
      <div class="flex flex-wrap items-baseline justify-between gap-x-4 gap-y-2 bg-white px-4 py-10 sm:px-6 xl:px-8">
        <dt class="text-sm font-medium leading-6 text-gray-500">Humidity</dt>
        <dd class="w-full flex-none text-3xl font-medium leading-10 tracking-tight text-gray-900 text-nowrap"><%= @measurement.humidity %>%</dd>
      </div>
    </dl>
    """
  end
end
