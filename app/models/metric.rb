class Metric < Couch::Model
  def add_data_point data
    @attributes['data'] ||= []
    @attributes['data'].push data
  end
end
