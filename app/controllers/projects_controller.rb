class ProjectsController < ApplicationController

  def index
    projects_response = Couch::Db.get('_design/projects/_view/with_nested_objectives')
    @projects = projects_response['rows']
  end

end
