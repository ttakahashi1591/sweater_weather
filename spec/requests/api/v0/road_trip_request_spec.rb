require "rails_helper"

RSpec.describe "Road trip endpoint" do
  before(:each) do
    user_params = {
      "email": "whatever@example.com",
      "password": "password",
      "password_confirmation": "password"
    }

    post "/api/v0/users", params: user_params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

    @user = User.last
  end

  describe "Happy Path" do 
    it "calculates travel time and the forecast it will be after that amount of time" do
      road_trip_params = {
        "origin": "Cincinatti,OH",
        "destination": "Chicago,IL",
        "api_key": @user.api_key
      }    

      post "/api/v0/road_trip", params: road_trip_params.to_json, headers: {'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json'}

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data).to have_key(:id)
      expect(data[:id]).to eq(nil)

      expect(data).to have_key(:type)
      expect(data[:type]).to eq("road_trip")

      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a(Hash)

      expect(data[:attributes]).to have_key(:start_city)
      expect(data[:attributes][:start_city]).to eq("Cincinatti,OH")

      expect(data[:attributes]).to have_key(:end_city)
      expect(data[:attributes][:end_city]).to eq("Chicago,IL")

      expect(data[:attributes]).to have_key(:travel_time)
      expect(data[:attributes][:travel_time]).to be_a(String)
      expect(data[:attributes][:travel_time]).to match(/\d{2}:\d{2}/)

      expect(data[:attributes]).to have_key(:weather_at_eta)
      expect(data[:attributes][:weather_at_eta]).to be_a(Hash)

      expect(data[:attributes][:weather_at_eta]).to have_key(:datetime)
      expect(data[:attributes][:weather_at_eta][:datetime]).to be_a(String)
      expect(data[:attributes][:weather_at_eta][:datetime]).to match(/\d{4}-\d{2}-\d{2} \d{2}:\d{2}/)

      expect(data[:attributes][:weather_at_eta]).to have_key(:temperature)
      expect(data[:attributes][:weather_at_eta][:temperature]).to be_a(Float)

      expect(data[:attributes][:weather_at_eta]).to have_key(:condition)
      expect(data[:attributes][:weather_at_eta][:condition]).to be_a(String)
    end
  end
end