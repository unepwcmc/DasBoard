class ProjectsController < ApplicationController

  def index
    @projects = Project.all
  end

  def show
    id = params[:id]
    result = Couch::Db.get(
      "_design/projects/_view/with_nested_objectives?startkey=[\"#{id}\", null]&endkey=[\"#{id}\", {}]"
    )
    @project = result['rows'][0]['value']
  end

end
