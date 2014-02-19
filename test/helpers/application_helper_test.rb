require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "hash_array_to_select_collection given a key name and value name,
   converts a hash to a 2D array" do
    hash = [{
      "_id" => "1",
      "name" => "metric"
    }]

    expected_array = [
      ["metric", "1"]
    ]

    result = hash_array_to_select_collection(hash, "_id", "name")

    assert_equal expected_array, result
  end
end
