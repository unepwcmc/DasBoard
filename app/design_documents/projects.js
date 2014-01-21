{
  _id: "_design/projects",
  views: {
    all: {
      map: function(doc) {
        if ((doc.type != null) && doc.type === 'project') {
          return emit(doc._id, doc);
        }
      }
    }
  }
};
