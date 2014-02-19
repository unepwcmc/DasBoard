class ObjectivesController < ApplicationController

  def new
    @objective = Objective.new({
      "name" => "New Objective",
      "type" => "objective",
      "project_id" => params[:id]
    })
    @objective.save

    @metrics = Metric.view('all').map {|m| m["value"]}

    render layout: false
  end

  def create
    render json: Couch::Db.post(params[:objective])
  end

end
