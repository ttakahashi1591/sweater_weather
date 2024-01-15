class Api::V1::MunchiesController < ApplicationController
  def show
	  munchies = MunchiesFacade.munchies_data(params[:destination], params[:food])

    render json: MunchiesSerializer.new(munchies).as_json
  end
end