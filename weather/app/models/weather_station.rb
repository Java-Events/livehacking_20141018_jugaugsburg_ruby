require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_ambient_light'
require 'tinkerforge/bricklet_barometer'
require 'tinkerforge/bricklet_temperature'
require 'tinkerforge/bricklet_humidity'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
AMBIENT_LIGHT = 'jy2'
BAROMETER = 'jY4'
TEMPERATURE = 'dXj'
HUMIDITY = 'kfd'

class WeatherStation

  attr_reader :lux, :air_pressure, :altitude, :centigrade, :relative_humidity

  def initialize
    @ipcon = IPConnection.new
    @ipcon.set_auto_reconnect(true)
    register_bricks
    connect
  end

  def lux
    @ambient_light.get_illuminance / 10.0
  end

  def air_pressure
    @barometer.get_air_pressure / 1000.0
  end

  def altitude
    @barometer.get_altitude / 100.0
  end

  def centigrade
    @temperature.get_temperature / 100.0
  end

  def relative_humidity
    @humidity.get_humidity / 10.0
  end

  private

    def register_bricks
      ambient_light
      barometer
      temperature
      humidity
    end

    def connect
      @ipcon.connect HOST, PORT
    end

    def disconnect
      @ipcon.disconnect
    end

    def ambient_light
      @ambient_light ||= BrickletAmbientLight.new AMBIENT_LIGHT, @ipcon
    end

    def barometer
      @barometer ||= BrickletBarometer.new BAROMETER, @ipcon
    end

    def temperature
      @temperature ||= BrickletTemperature.new TEMPERATURE, @ipcon
    end

    def humidity
      @humidity ||= BrickletHumidity.new HUMIDITY, @ipcon
    end

end