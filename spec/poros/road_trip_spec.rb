require "rails_helper"

RSpec.describe RoadTrip, :vcr do
  before(:each) do
    route = {start: "Cincinatti,OH", end: "Chicago,IL"}
    @directions = GeocodingFacade.new.route_data(route)
    @forecast = WeatherFacade.new.get_forecast(@directions[:boundingBox][:ul])
    @trip = RoadTrip.new(@directions, @forecast)
  end

  it "has the following attributes: a start location, end location, travel time, and weather forecast" do
    expect(@trip.start_city).to eq("Cincinnati, OH")
    expect(@trip.end_city).to eq("Chicago, IL")

    expect(@trip.travel_time).to be_a(String)
    expect(@trip.travel_time).to eq(@directions[:formattedTime])

    expect(@trip.weather_at_eta).to be_a(Hash)
    expect(@trip.weather_at_eta).to have_key(:datetime)
    expect(@trip.weather_at_eta[:datetime]).to be_a(String)

    expect(@trip.weather_at_eta).to have_key(:temperature)
    expect(@trip.weather_at_eta[:temperature]).to be_a(Float)

    expect(@trip.weather_at_eta).to have_key(:condition)
    expect(@trip.weather_at_eta[:condition]).to be_a(String)
  end

  describe "Class Methods" do
    it "#format_location" do
      formatted = @trip.format_location({
        adminArea1: "US",
        adminArea3: "CO",
        adminArea5: "Denver"
      })

      expect(formatted).to eq("Denver, CO")
    end

    it "#format_forecast and #find_forecast_hour" do
      chosen_hour = @trip.find_forecast_hour(@forecast)

      local_hour = @forecast[:location][:localtime].to_time.hour

      travel_hours = @directions[:formattedTime].to_time.hour

      if local_hour + travel_hours >= 24 
        expected = @forecast[:forecast][:forecastday][1][:hour][local_hour + travel_hours - 24]
      else
        expected = @forecast[:forecast][:forecastday][0][:hour][local_hour + travel_hours]
      end

      expect(chosen_hour).to eq(expected)
    end


    it "will provide N/A for invalid route data if an arguement is not present" do
      invalid_trip = RoadTrip.new({origin: "Cincinatti,OH", destination: "Paris, FR"})
  
      expect(invalid_trip.start_city).to eq("Cincinatti,OH")
      expect(invalid_trip.end_city).to eq("Paris, FR")
      expect(invalid_trip.travel_time).to eq("N/A")
      expect(invalid_trip.weather_at_eta).to eq({})
    end
  end
end