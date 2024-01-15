require "rails_helper"

RSpec.describe "Munchies Endpoint" do
  it "will return the current forecast summary & temperature for the city specified as well as a restaurant in that city including details: name, address, rating, and reviews" do
	get "/api/v1/munchies", params: {destination: "pueblo,co", food: "italian"}

    expect(response).to be_successful
    expect(response.status).to eq(200)

    munchies = JSON.parse(response.body, symbolize_names: true)

    expect(munchies).to have_key(:data)
    expect(munchies[:data]).to be_a(Hash)

    expect(munchies[:data]).to have_key(:id)
    expect(munchies[:data][:id]).to eq(nil)

    expect(munchies[:data]).to have_key(:type)
    expect(munchies[:data][:type]).to eq("munchie")

    expect(munchies[:data]).to have_key(:attributes)
    expect(munchies[:data][:attributes]).to be_a(Hash)

    expect(munchies[:data][:attributes]).to have_key(:destination_city)
    expect(munchies[:data][:attributes][:destination_city]).to be_a(String)

    expect(munchies[:data][:attributes]).to have_key(:forecast)
    expect(munchies[:data][:attributes][:forecast]).to be_a(Hash)
    expect(munchies[:data][:attributes][:forecast]).to have_key(:summary)
    expect(munchies[:data][:attributes][:forecast][:summary]).to be_a(String)
    expect(munchies[:data][:attributes][:forecast]).to have_key(:temperature)
    expect(munchies[:data][:attributes][:forecast][:temperature]).to be_a(String)

	  expect(munchies[:data][:attributes]).to have_key(:restaurant)
    expect(munchies[:data][:attributes][:restaurant]).to be_a(Hash)
    expect(munchies[:data][:attributes][:restaurant]).to have_key(:name)
    expect(munchies[:data][:attributes][:restaurant][:name]).to be_a(String)
    expect(munchies[:data][:attributes][:restaurant]).to have_key(:address)
    expect(munchies[:data][:attributes][:restaurant][:address]).to be_a(String)
    expect(munchies[:data][:attributes][:restaurant]).to have_key(:rating)
    expect(munchies[:data][:attributes][:restaurant][:rating]).to be_a(Float).or be_an(Integer)
    expect(munchies[:data][:attributes][:restaurant]).to have_key(:reviews)
    expect(munchies[:data][:attributes][:restaurant][:reviews]).to be_an(Integer)
  end
end