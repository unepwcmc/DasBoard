class Metric
  attr_accessor :attributes

  def initialize attributes = {}
    @attributes = attributes
  end

  def id
    @attributes['_id']
  end

  def self.find id
    attributes = Couch::Db.get(id)
    return new(attributes)
  end

  def self.all
    results = Couch::Db.get('_design/metrics/_view/all')
    results["rows"]
  end

  def save
    response = Couch::Db.put("/#{id}", @attributes)
    @attributes['_rev'] = response['rev']
  end

  def add_data_point data
    @attributes['data'] ||= []
    @attributes['data'].push data
  end
end
