class RoadTripFacade 
  def initialize(route)
    @route = route
  end

  def get_route_info 
    directions = geocoding.route_data(@route)

    return RoadTrip.new(@routes) if directions[:routeError]

    forecast = weather.get_forecast(directions[:boundingBox][:ul])
  
    RoadTrip.new(directions, forecast)
  end

  def geocoding 
    @geocoding ||= GeocodingFacade.new 
  end

  def weather 
    @weather ||= WeatherFacade.new
  end
end