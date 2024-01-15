class WeatherFacade 
  def get_forecast(location)
    response = service.forecast(coordinates(location))
  end

  def coordinates(location)
    GeocodingFacade.new.coordinates(location)
  end

  private 

  def service
    @service = WeatherService.new
  end
end