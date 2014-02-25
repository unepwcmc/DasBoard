class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end

  def show
    id = params[:id]
    @project = Project.find(id)
    @metrics = Metric.all
  end

  def new
    @project = Project.new(name: "New Project")
    @project.save!

    redirect_to project_path(@project)
  end

  def update
    @project = Project.find(params[:id])
    @project.update_attributes!(project_params)

    render json: @project
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
