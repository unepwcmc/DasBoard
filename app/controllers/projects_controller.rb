class ProjectsController < ApplicationController

  def index
    projects_response = Couch::Db.get('_design/projects/_view/all')
    @projects = projects_response['rows']
  end

  def show
    id = params[:id]
    project_response = Couch::Db.get("_all_docs/?key=#{id}")
    @project = project_response['rows']
  end

end
