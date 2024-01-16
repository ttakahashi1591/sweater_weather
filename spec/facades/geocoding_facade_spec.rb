require "rails_helper"

RSpec.describe GeocodingFacade, :vcr do
  it "will return the latitude and longitude data for a requested location" do
    facade = GeocodingFacade.new
    
    coordinates = facade.coordinates("cincinatti,oh")
    
    expect(coordinates).to be_a(Hash)
    expect(coordinates.count).to eq(2)

    expect(coordinates).to have_key(:lat)
    expect(coordinates[:lat]).to be_a(Float)

    expect(coordinates).to have_key(:lng)
    expect(coordinates[:lng]).to be_a(Float)
  end

  it "will return parsed route data for a requested start and end location" do
    facade = GeocodingFacade.new

    directions = facade.route_data({start: "Cincinatti,OH", end: "Chicago,IL"})

    expect(directions).to be_a(Hash)

    expect(directions).to have_key(:formattedTime)
    expect(directions[:formattedTime]).to be_a(String)
    expect(directions[:formattedTime]).to match(/\d{2}:\d{2}:\d{2}/)

    expect(directions).to have_key(:boundingBox)
    expect(directions).to be_a(Hash)

    expect(directions[:boundingBox]).to have_key(:ul)
    expect(directions[:boundingBox][:ul]).to have_key(:lat)
    expect(directions[:boundingBox][:ul][:lat]).to be_a(Float)

    expect(directions[:boundingBox][:ul]).to have_key(:lng)
    expect(directions[:boundingBox][:ul][:lng]).to be_a(Float)

    expect(directions[:boundingBox]).to have_key(:lr)
    expect(directions[:boundingBox][:lr]).to have_key(:lat)
    expect(directions[:boundingBox][:lr][:lat]).to be_a(Float)

    expect(directions[:boundingBox][:lr]).to have_key(:lng)
    expect(directions[:boundingBox][:lr][:lng]).to be_a(Float)  
  end
end