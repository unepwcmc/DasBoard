class Metric
  def self.all
    results = Couch::Db.get('_design/metrics/_view/all')
    results["rows"]
  end
end
