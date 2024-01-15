require "rails_helper"

RSpec.describe WeatherService, :vcr do
  it "supports with connecting to the Weather API" do
    service = WeatherService.new

    expect(service.conn).to be_a(Faraday::Connection)
  end

  it "returns current weather as well as the hourly weather for the next 5 days for a requested city" do
    service = WeatherService.new

    response = service.forecast({lat: 39.11, lng: -84.5})

    expect(response).to have_key(:location)
    expect(response).to have_key(:current)

    expect(response[:current]).to have_key(:last_updated)
    expect(response[:current]).to have_key(:temp_f)
    expect(response[:current]).to have_key(:feelslike_f)
    expect(response[:current]).to have_key(:humidity)
    expect(response[:current]).to have_key(:uv)
    expect(response[:current]).to have_key(:vis_miles)
    expect(response[:current]).to have_key(:condition)

    expect(response[:current][:condition]).to have_key(:text)
    expect(response[:current][:condition]).to have_key(:icon)

    expect(response).to have_key(:forecast)
    expect(response[:forecast]).to have_key(:forecastday)
    expect(response[:forecast][:forecastday]).to be_an(Array)
    expect(response[:forecast][:forecastday].count).to eq(5)

    response[:forecast][:forecastday].each do |day|
      expect(day).to have_key(:date)
      expect(day).to have_key(:astro)

      expect(day[:astro]).to have_key(:sunrise)
      expect(day[:astro]).to have_key(:sunset)

      expect(day).to have_key(:day)
      expect(day[:day]).to have_key(:maxtemp_f)
      expect(day[:day]).to have_key(:mintemp_f)
      expect(day[:day]).to have_key(:condition)
      expect(day[:day][:condition]).to have_key(:text)
      expect(day[:day][:condition]).to have_key(:icon)

      expect(day).to have_key(:hour)
      expect(day[:hour]).to be_an(Array)
      expect(day[:hour].count).to eq(24)

      day[:hour].each do |hour|
        expect(hour).to have_key(:time)
        expect(hour).to have_key(:temp_f)
        expect(hour).to have_key(:condition)
        expect(hour[:condition]).to have_key(:text)
        expect(hour[:condition]).to have_key(:icon)
      end
    end
  end
end