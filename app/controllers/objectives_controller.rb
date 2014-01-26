class ObjectivesController < ApplicationController

  def show
    @objective = Couch::Db.get("/#{params['id']}")
  end

end
