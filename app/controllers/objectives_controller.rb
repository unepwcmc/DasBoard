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

  def update
    objective = Objective.find(params[:id])
    objective.update({
      metric_id: params[:metric_id]
    })

    objective.attributes[:metric] = Metric.find(params[:metric_id]).attributes

    render json: objective.attributes
  end

  def create
    render json: Couch::Db.post(params[:objective])
  end

end
