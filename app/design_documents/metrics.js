{
  _id: "_design/metrics",
  views: {
    all: {
      map: function(doc) {
        if (doc.type == 'metric') {
          emit(doc._id, doc);
        }
      }
    }
  }
};
