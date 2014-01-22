require(File.join(Rails.root, 'lib', 'couch_db.rb'))

Couch.load_config()
Couch::Db.create_database()
Couch.load_design_documents()
