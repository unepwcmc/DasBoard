require 'v8'

class CouchDb
  def self.load_config
    @@host = 'localhost'
    @@port = '5984'
    @@db_name = 'das_board'
  end

  def self.base_url
    "http://#{@@host}:#{@@port}/"
  end

  def self.connection
    conn = Faraday.new(:url => self.base_url) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    conn
  end

  def self.get id
    response = connection.get("/#{@@db_name}/#{id}")
    response.body
  end

  def self.put id, body
    response = connection.put do |req|
      req.url "#{@@db_name}/#{id}"
      req.headers['Content-Type'] = 'application/json'
      req.body = body
    end
    p response
    response.body
  end

  def self.load_design_documents
    docs = Dir.glob(File.join(Rails.root, 'app', 'design_documents', '*.js'))
    docs.each do |doc_name|
      doc_id = File.basename(doc_name, '.js')
=begin
      puts "looking for #{doc_id}"
      existing_document = self.get("_design/#{doc_id}")

      if !existing_document.match /error/
        puts "Oh, it's not there:"
        puts existing_document.error
      else
        puts "found #{existing_document}"
      end
=end


      doc = File.read(doc_name)
      docJson = self.read_design_document(doc)
      puts self.put("_design/#{doc_id}", docJson)
    end
  end

  def self.read_design_document document_text
    cxt = V8::Context.new
    cxt.eval("
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

      doc = #{document_text}
      convertFunctionsToStrings(doc);
      JSON.stringify(doc);
    ")
  end

end
