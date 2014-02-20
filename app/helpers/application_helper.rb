module ApplicationHelper

  def hash_array_to_select_collection collection, key, value_field
    collection.collect {|i| [ i[value_field], i[key] ] }
  end
end
