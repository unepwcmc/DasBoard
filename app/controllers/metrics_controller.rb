class MetricsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    render json: Metric.all
  end

  def new
    @metric = Metric.new(name: "New Metric")
    @metric.save!

    redirect_to metric_path(@metric)
  end

  def show
    @metric = Metric.find(params[:id])
  end

  def data
    metric = Metric.find params[:id]
    metric.add_data_point(params[:data])
    metric.save

    render json: metric
  end
end
