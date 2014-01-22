require(File.join(Rails.root, 'lib', 'couch_db.rb'))

CouchDb.load_config()
CouchDb.create_database()
CouchDb.load_design_documents()
