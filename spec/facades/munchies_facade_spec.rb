require 'rails_helper'

RSpec.describe MunchiesFacade, :vcr do
  it "returns munchies data for a destination and food type" do
    facade = MunchiesFacade.new("Pueblo, CO", "italian")

    munchies_data = facade.munchies_data
require 'pry'; binding.pry
    expect(munchies_data).to be_a(Hash)
    expect(munchies_data).to have_key(:destination_city)
    expect(munchies_data).to have_key(:forecast)
    expect(munchies_data).to have_key(:restaurant)
  end
end