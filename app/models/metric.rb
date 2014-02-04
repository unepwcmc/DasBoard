class Metric < Couch::Model
  def self.all
    results = Couch::Db.get('_design/metrics/_view/all')
    results["rows"]
  end

  def add_data_point data
    @attributes['data'] ||= []
    @attributes['data'].push data
  end
end
