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
end