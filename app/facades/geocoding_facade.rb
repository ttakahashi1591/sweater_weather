class GeocodingFacade 
  def coordinates(location)
    response = service.location_data(location)
    
    response[:results][0][:locations][0][:displayLatLng]
  end

  def route_data(route)
    response = service.directions_data(route)

    response[:route]
  end

  def service 
    @service ||= GeocodingService.new
  end
end