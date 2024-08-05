# AirSensor

A demonstration of a Phoenix LiveView application that displays air quality data from a sensor,
through Rustler-powered NIFs.

The companion repository to a YouTube video:

[![Watch the video](https://img.youtube.com/vi/JsdM3k3QiPc/maxresdefault.jpg)](https://youtu.be/JsdM3k3QiPc)

## Requirements
- Erlang & Elixir
- Rust (You can install Rust by following the instructions at [rustup.rs](https://rustup.rs/))
- An Aranet4 air quality sensor
- A computer that supports Bluetooth Low Energy (BLE)

## Running
To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
If everything is set up correctly, you should see the latest reading from your sensor on the page.
