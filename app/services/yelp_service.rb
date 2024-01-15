class YelpService < ApplicationService
  def conn 
    Faraday.new("https://api.yelp.com/v3/") do |faraday|
      faraday.headers["Authorization"] = Rails.application.credentials.yelp[:key]
    end
  end

  def get_url(url)
    conn.get(url)
  end 

  def return_restaurant(latitude, longitude, type)
    response = get_url("businesses/search?latitude=#{latitude}&longitude=#{longitude}&term=#{type}&limit=1")

    json_parse(response)
  end
end