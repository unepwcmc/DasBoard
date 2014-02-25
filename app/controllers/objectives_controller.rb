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
    objective.update_attributes(objective_params)
    objective.save

    objectiveJSON = objective.attributes

    if objective.metric
      objectiveJSON[:metric] = objective.metric.attributes
    end

    render json: objectiveJSON
  end

  def destroy
    objective = Objective.find(params[:id])
    objective.destroy!

    render json: objective
  end

  def create
    render json: Couch::Db.post(params[:objective])
  end

  private

  def objective_params
    params.require(:objective).permit(:metric_id, :name, :threshold)
  end
end
