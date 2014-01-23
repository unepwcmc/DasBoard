require 'test_helper'

class CouchTest < ActiveSupport::TestCase
  test '#get throws an error when CouchDB returns an error' do
    Couch.stubs(:connection).
      returns(
        Struct.new(:attr) {
          def get url
            Struct.new(:body).new({
              'error' => 'bidi bidi bidi',
              'reason' => 'db db db'
            }.to_json)
          end
        }.new
      )


    assert_raises(Couch::Exception) {
      Couch.get('http://localhost:5984')
    }
  end
end
