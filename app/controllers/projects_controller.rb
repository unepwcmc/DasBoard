class ProjectsController < ApplicationController

  def index
    projects_response = Couch::Db.get('_designs/projects/_views/all')
    @projects = projects_response['rows']
  end

end
