class Api::V1::MunchiesController < ApplicationController
  def show
	  munchies = YelpFacade.city_search(params[:destination], params[:food])

    render json: MunchiesSerializer.new(munchies).as_json
  end
end