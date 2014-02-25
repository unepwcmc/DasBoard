class AddEventsToObjective < ActiveRecord::Migration
  def change
    add_column :events, :objective_id, :integer
  end
end
