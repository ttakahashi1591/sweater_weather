require "rails_helper"

RSpec.describe GeocodingService, :vcr do
  it "supports with connecting to the Mapquest API" do
    service = GeocodingService.new

    expect(service.conn).to be_a(Faraday::Connection)
  end

  it "returns location details for a requested city" do
    service = GeocodingService.new

    response = service.location_data("cincinatti,oh")

    data = JSON.parse(response.body, symbolize_names: true)
    
    coordinates = data[:results][0][:locations][0][:displayLatLng]
    
    expect(coordinates).to have_key(:lat)
    expect(coordinates[:lat]).to be_a(Float)

    expect(coordinates).to have_key(:lng)
    expect(coordinates[:lng]).to be_a(Float)
  end
end