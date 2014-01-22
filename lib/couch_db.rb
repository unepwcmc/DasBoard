require 'v8'
require 'json'

class CouchDb
  def self.load_config
    @@host = 'localhost'
    @@port = '5984'
    @@db_name = 'das_board'
  end

  def self.create_database
    self.put "", {}
  end

  def self.base_url
    "http://#{@@host}:#{@@port}/"
  end

  def self.connection
    conn = Faraday.new(:url => self.base_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    conn
  end

  def self.get id
    response = connection.get("/#{@@db_name}/#{id}")
    JSON.parse response.body
  end

  def self.put id, body
    response = connection.put do |req|
      req.url "#{@@db_name}/#{id}"
      req.headers['Content-Type'] = 'application/json'
      req.body = body.to_json
    end
    JSON.parse response.body
  end

  def self.load_design_documents
    docs = Dir.glob(File.join(Rails.root, 'app', 'design_documents', '*.js'))
    docs.each do |doc_path|
      doc_id = File.basename(doc_path, '.js')

      doc_json = self.read_design_document doc_path

      puts "looking for #{doc_id}"
      existing_document = self.get("_design/#{doc_id}")

      if existing_document['error'].nil?
        _rev = existing_document.delete('_rev')
        puts "Found existing _rev #{_rev}"
        if existing_document != doc_json
          puts existing_document
          puts doc_json
          puts "Definition has changed, updating..."
          doc_json['_rev'] = _rev
          puts self.put("_design/#{doc_id}", doc_json)
        end
      else
        puts "design document not found, inserting..."
        puts self.put("_design/#{doc_id}", doc_json)
      end
    end
  end

  def self.read_design_document file_path
    doc_js = File.read(file_path)

    cxt = V8::Context.new
    doc_json = cxt.eval("
      convertFunctionsToStrings = function(document) {
        var action, fn, functions, viewName, _ref, _results;
        _ref = document.views;
        _results = [];
        for (viewName in _ref) {
          functions = _ref[viewName];
          _results.push((function() {
            var _results1;
            _results1 = [];
            for (action in functions) {
              fn = functions[action];
              _results1.push(document.views[viewName][action] = fn.toString());
            }
            return _results1;
          })());
        }
        return _results;
      };

      doc = #{doc_js}
      convertFunctionsToStrings(doc);
      JSON.stringify(doc);
    ")
    JSON.parse(doc_json)
  end

end
