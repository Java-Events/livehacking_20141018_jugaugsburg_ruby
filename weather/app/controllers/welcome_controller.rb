class WelcomeController < ApplicationController
  def index
    @weather_station = WeatherStation.new
  end
end
