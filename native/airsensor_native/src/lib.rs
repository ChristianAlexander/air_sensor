use aranet4::sensor;
use rustler::{Env, Error, NifStruct, Resource, ResourceArc};
use tokio::runtime::Runtime;

#[derive(NifStruct)]
#[module = "AirSensor.Native.SensorReading"]
struct SensorReading {
    pub co2_level: u16,
    pub temperature: f32,
    pub pressure: f32,
    pub humidity: u8,
    pub battery: u8,
}

struct Handle {
    pub sensor: sensor::Sensor,
}

#[rustler::resource_impl]
impl Resource for Handle {}

#[rustler::nif(schedule = "DirtyIo")]
fn init() -> Result<ResourceArc<Handle>, Error> {
    let rt = Runtime::new().unwrap();
    match rt.block_on(sensor::SensorManager::init(None)) {
        Ok(sensor) => Ok(ResourceArc::new(Handle { sensor })),
        Err(_error) => Err(Error::Term(Box::new("Failed to load sensor"))),
    }
}

#[rustler::nif(schedule = "DirtyIo")]
#[allow(unused_variables)]
fn read(env: Env, handle: ResourceArc<Handle>) -> Result<SensorReading, Error> {
    let rt = Runtime::new().unwrap();

    rt.block_on(async {
        let reading = handle.sensor.read_current_values().await;

        match reading {
            Ok(reading) => Ok(SensorReading {
                co2_level: reading.co2_level,
                temperature: reading.temperature,
                pressure: reading.pressure,
                humidity: reading.humidity,
                battery: reading.battery,
            }),
            Err(_) => Err(Error::Term(Box::new("Failed to read sensor values"))),
        }
    })
}

rustler::init!("Elixir.AirSensor.Native");
