{
  _id: "_design/projects",
  views: {
    all: {
      map: function(doc) {
        if (doc.type == 'project') {
          emit([doc._id, 0, doc.type], doc);
        }
      }
    }, 
    with_objectives: {
      map: function(doc) {
        if (doc.type == 'project') {
          emit([doc._id, 0, doc.type], doc);
        } else if (doc.type == 'objective') {
          emit([doc.project_id, 1, doc.type], doc);
        }
      }
    }
  }
};
