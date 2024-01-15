class MunchiesFacade
  def initialize(location, type)
    @location = location
    @type = type
  end

  def munchies_data
    coordinates = geocoding_service.location_data(@location)[:results][0][:locations][0][:displayLatLng]
    restaurant_data = yelp_service.return_restaurant(coordinates[:lat], coordinates[:lng], @type)[:businesses][0]
    forecast_data = weather_service.forecast(coordinates)[:current]

    result_hash = {
      data: {
        id: nil,
        type: "munchie",
        attributes: {
          destination_city: "#{restaurant_data[:location][:city]}, #{restaurant_data[:location][:state]}",
          forecast: {
            summary: forecast_data[:condition][:text],
            temperature: forecast_data[:temp_f].to_s
          },
          restaurant: {
            name: restaurant_data[:name],
            address: restaurant_data[:location][:display_address].join(", "),
            rating: restaurant_data[:rating],
            reviews: restaurant_data[:review_count]
          }
        }
      }
    }

    result_hash
  end

  private

  def geocoding_service
    @geocoding_service ||= GeocodingService.new
  end

  def yelp_service
    @yelp_service ||= YelpService.new
  end

  def weather_service
    @weather_service ||= WeatherService.new
  end
end