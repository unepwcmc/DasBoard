class Metric < ActiveRecord::Base
  def add_data_point data
    self.data ||= []

    cloned_data = self.data.clone
    cloned_data.push data

    self.data = cloned_data
  end
end
