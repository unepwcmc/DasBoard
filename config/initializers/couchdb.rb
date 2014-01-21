require(File.join(Rails.root, 'lib', 'couch_db.rb'))

CouchDb.load_config()
CouchDb.load_design_documents()

