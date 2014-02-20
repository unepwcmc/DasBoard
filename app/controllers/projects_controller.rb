class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end

  def show
    id = params[:id]
    @project = Project.find(id)
    @metrics = Metric.all
  end

end
