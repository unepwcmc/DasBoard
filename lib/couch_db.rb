require 'v8'
require 'json'

class Couch
  def self.load_config
    @@host = 'localhost'
    @@port = '5984'

    env = Rails.env || 'development'
    Couch::Db.set_db("das_board_#{env}")
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
    json = JSON.parse response.body
    raise Couch::Exception.new(json) if json['error'].present?
    return json
  end

  def self.put url, body=""
    response = connection.put do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.body = body.to_json
    end
    JSON.parse response.body
  end

  def self.design_documents
    Dir.glob(File.join(Rails.root, 'app', 'design_documents', '*.js'))
  end

  def self.load_design_documents
    @docs ||= design_documents

    @docs.each do |doc_path|
      doc_id = File.basename(doc_path, '.js')
      doc_json = self.read_design_document doc_path

      begin
        existing_document = self::Db.get("_design/#{doc_id}")
        _rev = existing_document.delete('_rev')
        if existing_document != doc_json
          doc_json['_rev'] = _rev
        end
      rescue Couch::Exception
      ensure
        Couch::Db.put("_design/#{doc_id}", doc_json)
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

  class Exception < StandardError
  end

  class Db
    def self.set_db db_name
      @@db_name = db_name
    end

    def self.create_database
      Couch.put "/#{@@db_name}/"
    end

    def self.delete_database
      Couch.delete "/#{@@db_name}/"
    end

    def self.get id
      Couch.get "#{@@db_name}/#{id}"
    end

    def self.put id, body
      Couch.put "#{@@db_name}/#{id}", body
    end

    def self.post body=""
      response = Couch.connection.post do |req|
        req.url "/#{@@db_name}"
        req.headers['Content-Type'] = 'application/json'
        req.body = body.to_json
      end
      JSON.parse response.body
    end
  end
end
