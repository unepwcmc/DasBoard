class ObjectivesController < ApplicationController

  def new
    @objective = Objective.create({
      "name" => "New Objective",
      "project_id" => params[:id]
    })

    @metrics = Metric.all

    render layout: false
  end

  def update
    objective = Objective.find(params[:id])
    objective.metric_id = params[:metric_id]
    objective.save

    objectiveJSON = objective.attributes
    objectiveJSON[:metric] = objective.metric.attributes

    render json: objectiveJSON
  end

  def create
    render json: Couch::Db.post(params[:objective])
  end

end
