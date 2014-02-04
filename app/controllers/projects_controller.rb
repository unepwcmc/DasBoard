class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end

  def show
    id = params[:id]
    result = Project.find_with_nested_objectives(id)
    @project = result[0]['value']
    Project.populate_metrics_on_objectives!(@project)
  end

end
