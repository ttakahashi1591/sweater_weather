class Api::V0::ForecastController < ApplicationController
  def index
    forecast = ForecastFacade.city_search(params[:location])

    render json: ForecastSerializer.new(forecast).as_json
  end
end