class GeocodingService < ApplicationService
  def conn
    Faraday.new("https://www.mapquestapi.com") do |faraday|
      faraday.params["key"] = Rails.application.credentials.geocoding[:key]
    end
  end

  def get_url(url)
    conn.get(url)
  end

  def location_data(location)
    get_url("/geocoding/v1/address") do |faraday|
      faraday.params[:location] = location
    end
  end
end