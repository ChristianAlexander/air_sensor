defmodule AirSensor.Native do
  use Rustler,
    otp_app: :air_sensor,
    crate: :airsensor_native

  defmodule SensorReading do
    defstruct [:co2_level, :temperature, :pressure, :humidity, :battery]
  end

  def init(), do: :erlang.nif_error(:nif_not_loaded)
  def read(_handle), do: :erlang.nif_error(:nif_not_loaded)
end
