class Project < ActiveRecord::Base
  def self.find_with_nested_objectives key=nil
    query = '_design/projects/_view/with_objectives'
    if key.present?
      query += "?startkey=[\"#{key}\", null]&endkey=[\"#{key}\", {}]"
    end

    results = Couch::Db.get(query)

    projects = []
    results['rows'].each do |result|
      if result['key'][1] == 0
        # Project
        project = result
        project['value']['objectives'] = []
        projects.push project
      else
        # Objective
        projects.last['value']['objectives'].push result['value']
      end
    end

    projects
  end

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
