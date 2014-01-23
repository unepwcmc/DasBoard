class ProjectsController < ApplicationController

  def index
    project_response = Couch::Db.get('_designs/projects/_views/all')
    @projects = project_response['rows']
  end

end
