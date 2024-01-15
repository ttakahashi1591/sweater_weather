require "rails_helper"

RSpec.describe YelpService, :vcr do
  it "supports with connecting to the Yelp Fusion API" do
    service = YelpService.new

    expect(service.conn).to be_a(Faraday::Connection)
  end

  it "returns one restaurant and its data based off a requested city coordinates" do
    service = YelpService.new

    response = service.return_restaurant(38.276463, -104.604607, "italian")

    expect(response).to be_a(Hash)

    expect(response).to have_key(:businesses)
    expect(response[:businesses]).to be_an(Array)

    expect(response[:businesses][0]).to have_key(:id)
    expect(response[:businesses][0][:id]).to be_a(String)

    expect(response[:businesses][0]).to have_key(:name)
    expect(response[:businesses][0][:name]).to be_a(String)

    expect(response[:businesses][0]).to have_key(:review_count)
    expect(response[:businesses][0][:review_count]).to be_an(Integer)

    expect(response[:businesses][0]).to have_key(:rating)
    expect(response[:businesses][0][:rating]).to be_a(Float).or be_an(Integer)

    expect(response[:businesses][0]).to have_key(:location)
    expect(response[:businesses][0][:location]).to be_a(Hash)
    expect(response[:businesses][0][:location]).to have_key(:display_address)
    expect(response[:businesses][0][:location][:display_address]).to be_an(Array)
  end
end