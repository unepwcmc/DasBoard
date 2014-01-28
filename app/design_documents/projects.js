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
    with_nested_objectives: {
      map: function(doc) {
        if (doc.type == 'project') {
          emit([doc._id, 0, doc.type], doc);
        } else if (doc.type == 'objective') {
          emit([doc.project_id, 1, doc.type], doc);
        }
      },
      reduce: function(keys, values) {
        var parentProject = null;
        var childObjectives = [];
        for (var i=0, il=values.length; i<il; i++) {
          var value = values[i];
          var type = keys[i][0][1];
          if (type === 0) {
            parentProject = value;
          } else {
            childObjectives.push(value);
          }
        }

        parentProject.objectives = childObjectives;

        return parentProject;
      }
    }
  }
};
