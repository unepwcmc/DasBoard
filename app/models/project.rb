class Project
  def self.all
    results = Couch::Db.get('_design/projects/_view/all')
    results["rows"]
  end

  def self.find_with_nested_objectives key=nil
    query = '_design/projects/_view/with_nested_objectives?group=true&group_level=1'
    if key.present?
      query += "&startkey=[\"#{key}\", null]&endkey=[\"#{key}\", {}]"
    end

    Couch::Db.get(query)
  end
end
