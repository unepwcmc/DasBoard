class Metric < ActiveRecord::Base
  def add_data_point data
    puts "changing data to : #{data}"
    self.data ||= []
    puts "Data object id am: #{self.data.object_id}"
    cloned_data = self.data.clone
    puts "cloned object id am: #{cloned_data.object_id}"
    self.data = cloned_data
    puts "Changes to data: #{self.changes}"
  end
end
