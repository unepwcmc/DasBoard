class MetricsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    render json: Metric.all
  end

  def data
    metric = Metric.find params[:id]
    metric.add_data_point(params[:data])
    metric.save

    render json: metric.attributes
  end
end
