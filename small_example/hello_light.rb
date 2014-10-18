#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

# run 'gem install tinkerforge'
# change HOST, PORT, LCD_UID, AL_UID, MT_UID to your values
# run 'chmod +x hello_light.rb'
# run './hello_light.rb'
# Speed is 1000 times the value of the pushed button

require 'tinkerforge/ip_connection'
require 'tinkerforge/bricklet_lcd_20x4'
require 'tinkerforge/bricklet_ambient_light'
require 'tinkerforge/bricklet_multi_touch'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
LCD_UID = 'oco'
AL_UID = 'm89'
MT_UID = 'jV7'

ipcon = IPConnection.new

lcd = BrickletLCD20x4.new LCD_UID, ipcon
al = BrickletAmbientLight.new AL_UID, ipcon
mt = BrickletMultiTouch.new MT_UID, ipcon

ipcon.set_auto_reconnect true
ipcon.connect HOST, PORT

if lcd.is_backlight_on
  lcd.clear_display
  lcd.backlight_off
  sleep 2
end

lcd.backlight_on

speed = 1000

mt.recalibrate

mt.register_callback(BrickletMultiTouch::CALLBACK_TOUCH_STATE) do |touch_state|
  unless (touch_state & 0xFFF) == 0
    for i in 0..11
      if (touch_state & (1 << i)) == (1 << i)
          speed = i.to_i * 1000
      end
    end
  end

  lcd.write_line 3, 0, "Speed: #{speed} ms"
  al.set_illuminance_callback_period(speed)

  al.register_callback(BrickletAmbientLight::CALLBACK_ILLUMINANCE) do |illuminance|
    lcd.write_line 0, 0, "Illuminance: #{illuminance/10.0} Lux"
  end
end

puts 'Press key to exit'
$stdin.gets
ipcon.disconnect