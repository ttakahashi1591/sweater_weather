require "rails_helper" 

RSpec.describe RoadTripFacade, :vcr do
  it "returns directions for the route requested" do
    facade = RoadTripFacade.new({start: "Cincinatti,OH", end: "Chicago,IL"})

    route = facade.get_route_info

    expect(route).to be_a(RoadTrip)
    expect(route.start_city).to eq("Cincinnati, OH")
    expect(route.end_city).to eq("Chicago, IL")
    expect(route.travel_time).to be_a(String)
    expect(route.weather_at_eta).to be_a(Hash)
    expect(route.weather_at_eta[:datetime]).to be_a(String)
    expect(route.weather_at_eta[:temperature]).to be_a(Float)
    expect(route.weather_at_eta[:condition]).to be_a(String)
  end
end