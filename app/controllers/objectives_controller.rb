class ObjectivesController < ApplicationController

  def create
    render json: Couch::Db.post(params[:objective])
  end

end
