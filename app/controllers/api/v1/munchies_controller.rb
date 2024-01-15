class Api::V1::MunchiesController < ApplicationController
  def index
	  facade = MunchiesFacade.new(params[:destination], params[:food])

    render json: facade.munchies_data
  end
end