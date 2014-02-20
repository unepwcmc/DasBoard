class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end

  def show
    id = params[:id]
    @project = Project.find(id)
    @metrics = Metric.all
  end

  def update
    @project = Project.find(params[:id])
    @project.update_attributes!(project_params)

    render json: @project
  end

  private

  def project_params
    params.permit(:name)
  end
end
