class WeatherFacade 
  def get_forecast(location, coordinates = nil)
    response = service.forecast(coordinates || get_coordinates(location))
  end

  def get_coordinates(location)
    GeocodingFacade.new.coordinates(location)
  end

  private 

  def service
    @service = WeatherService.new
  end
end