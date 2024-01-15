require 'rails_helper'

RSpec.describe MunchiesFacade, :vcr do
  it "returns munchies data for a destination and food type" do
    facade = MunchiesFacade.new("Pueblo, CO", "italian")

    munchies_data = facade.munchies_data

    expect(munchies_data[:data]).to be_a(Hash)

    expect(munchies_data[:data]).to have_key(:attributes)
    expect(munchies_data[:data][:attributes]).to be_a(Hash)

    expect(munchies_data[:data][:attributes]).to have_key(:destination_city)
    expect(munchies_data[:data][:attributes][:destination_city]).to be_a(String)

    expect(munchies_data[:data][:attributes]).to have_key(:forecast)
    expect(munchies_data[:data][:attributes][:forecast]).to be_a(Hash)
    expect(munchies_data[:data][:attributes][:forecast]).to have_key(:summary)
    expect(munchies_data[:data][:attributes][:forecast][:summary]).to be_a(String)
    expect(munchies_data[:data][:attributes][:forecast]).to have_key(:temperature)
    expect(munchies_data[:data][:attributes][:forecast][:temperature]).to be_a(String)

    expect(munchies_data[:data][:attributes]).to have_key(:restaurant)
    expect(munchies_data[:data][:attributes][:restaurant]).to be_a(Hash)
    expect(munchies_data[:data][:attributes][:restaurant]).to have_key(:name)
    expect(munchies_data[:data][:attributes][:restaurant][:name]).to be_a(String)
    expect(munchies_data[:data][:attributes][:restaurant]).to have_key(:address)
    expect(munchies_data[:data][:attributes][:restaurant][:address]).to be_a(String)
    expect(munchies_data[:data][:attributes][:restaurant]).to have_key(:rating)
    expect(munchies_data[:data][:attributes][:restaurant][:rating]).to be_a(Float).or be_an(Integer)
    expect(munchies_data[:data][:attributes][:restaurant]).to have_key(:reviews)
    expect(munchies_data[:data][:attributes][:restaurant][:reviews]).to be_an(Integer)
  end
end