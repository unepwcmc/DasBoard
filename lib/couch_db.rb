require 'v8'
require 'json'

class CouchDb
  def self.load_config
    @@host = 'localhost'
    @@port = '5984'

    env = Rails.env || 'development'
    @@db_name = "das_board_#{env}"
  end

  def self.create_database
    self.put "/#{@@db_name}/"
  end

  def self.delete_database
    self.delete "/#{@@db_name}/"
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

  def self.delete url
    response = connection.delete(url)
    JSON.parse response.body
  end

  def self.get url
    response = connection.get(url)
    JSON.parse response.body
  end

  def self.put url, body=""
    response = connection.put do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.body = body.to_json
    end
    JSON.parse response.body
  end

  def self.get_by_id id
    self.get "#{@@db_name}/#{id}"
  end

  def self.design_documents
    Dir.glob(File.join(Rails.root, 'app', 'design_documents', '*.js'))
  end

  def self.load_design_documents
    @docs ||= design_documents

    @docs.each do |doc_path|
      doc_id = File.basename(doc_path, '.js')
      doc_json = self.read_design_document doc_path

      existing_document = self.get_by_id("_design/#{doc_id}")

      if existing_document['error'].nil?
        _rev = existing_document.delete('_rev')
        if existing_document != doc_json
          doc_json['_rev'] = _rev
        end
      end

      self.put("#{@@db_name}/_design/#{doc_id}", doc_json)
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
