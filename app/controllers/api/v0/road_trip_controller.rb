class Api::V0::RoadTripController < ApplicationController
  before_action :validate_key

  def create
    facade = RoadTripFacade.new.(road_trip_params)
    
    road_trip = facade.get_route_info
    require 'pry'; binding.pry
    render json: RoadTripSerializer.new(road_trip)
  end

  private

  def road_trip_params
    params.permit(:origin, :destination)
  end

  def validate_key
    User.find_by!(api_key: params[:api_key])
  end
end