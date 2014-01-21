{
  _id: "_design/projects",
  views: {
    all: {
      map: function(doc) {
        if ((doc.type != null) && doc.type === 'projects') {
          return emit(doc._id, doc);
        }
      }
    }
  }
};
