class WeatherService < ApplicationService
  def conn 
    Faraday.new("http://api.weatherapi.com/v1/") do |faraday|
      faraday.params[:key] = Rails.application.credentials.weather[:key]
    end
  end

  def get_url(url)
    conn.get(url)
  end 

  def forecast(coordinates)
    # json_parse(get_url("forecast.json")) do |faraday|
    #   faraday.params[:q] = "#{coordinates[:lat]},#{coordinates[:lng]}"
    #   faraday.params[:days] = 5
    # end
    response = get_url("forecast.json?q=#{coordinates[:lat]},#{coordinates[:lng]}&days=5")

    json_parse(response)
  end
end