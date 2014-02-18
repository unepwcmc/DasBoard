class ObjectivesController < ApplicationController

  def new
    @objective = Objective.new({
      "name" => "New Objective",
      "type" => "objective",
      "project_id" => params[:id]
    })
    @objective.save

    render layout: false
  end

  def create
    render json: Couch::Db.post(params[:objective])
  end

end
