class Api::V1::MunchiesController < ApplicationController
  def show
    require 'pry'; binding.pry
	  munchies = MunchiesFacade.munchies_data(params[:destination], params[:food])

    render json: MunchieSerializer.new(munchies)
  end
end