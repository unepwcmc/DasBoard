class Project < ActiveRecord::Base
  has_many :objectives

  def self.populate_metrics_on_objectives! project
    metric_ids = project['objectives'].map{|objective|
      objective['metric_id']
    }

    metric_ids.compact!
    return if metric_ids.length == 0
    metric_ids.sort!

    result = Couch::Db.get(
      "_design/metrics/_view/all?startkey=\"#{metric_ids.first}\"&endkey=\"#{metric_ids.last}\""
    )
    metrics = result['rows']

    project['objectives'].each do |objective|
      metric_id = objective['metric_id']
      metrics.each do |row|
        if row['key'] == metric_id
          objective['metric'] = row['value']
          break
        end
      end
    end
  end
end
