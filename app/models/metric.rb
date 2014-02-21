class Metric < ActiveRecord::Base
  def add_data_point data
    self.data ||= []

    # Clone the current Metric data
    #
    # The Postgres ActiveRecord adapter does not detect changes to the
    # data when a value is pushed to it. This is because it is the same
    # object (the adapter uses a simple == equality check). The clone
    # changes the object_id and forces the adapter to be aware of the
    # change to the array.
    cloned_data = self.data.clone
    cloned_data.push data

    self.data = cloned_data
  end
end
