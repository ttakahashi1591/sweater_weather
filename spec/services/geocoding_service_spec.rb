require "rails_helper"

RSpec.describe GeocodingService, :vcr do
  it "supports with connecting to the Mapquest API" do
    service = GeocodingService.new

    expect(service.conn).to be_a(Faraday::Connection)
  end
  
  it "returns location details for a requested city" do
    service = GeocodingService.new
    
    response = service.location_data("cincinatti,oh")
    
    coordinates = response[:results][0][:locations][0][:displayLatLng]
    
    expect(coordinates).to have_key(:lat)
    expect(coordinates[:lat]).to be_a(Float)

    expect(coordinates).to have_key(:lng)
    expect(coordinates[:lng]).to be_a(Float)
  end

  it "support with gets directions for a requested city" do
    service = GeocodingService.new

    directions = service.directions_data({start: "Cincinatti,OH", end: "Chicago,IL"})

    expect(directions).to have_key(:route)
    expect(directions[:route]).to have_key(:formattedTime)
    expect(directions[:route][:formattedTime]).to match(/\d{2}:\d{2}:\d{2}/)
    expect(directions[:route]).to have_key(:boundingBox)

    expect(directions[:route][:boundingBox].keys).to match_array([:ul, :lr])
    expect(directions[:route][:boundingBox][:ul]).to have_key(:lat)
    expect(directions[:route][:boundingBox][:ul]).to have_key(:lng)

    expect(directions[:route][:boundingBox][:lr]).to have_key(:lat)
    expect(directions[:route][:boundingBox][:lr]).to have_key(:lng)
  end
end