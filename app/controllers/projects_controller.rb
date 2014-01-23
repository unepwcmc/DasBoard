class ProjectsController < ApplicationController

  def index
    projects_response = Couch::Db.get('_design/projects/_view/all')
    @projects = projects_response['rows']
  end

end
