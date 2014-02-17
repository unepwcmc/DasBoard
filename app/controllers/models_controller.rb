class ModelsController < ApplicationController

  def update
    model_attributes = Couch::Db.get(params["id"])

    klass = model_attributes['type'].classify.constantize

    model = klass.new(model_attributes)
    model.update(params[:model])

    render json: model.attributes
  end

end