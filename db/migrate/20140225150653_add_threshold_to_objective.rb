class AddThresholdToObjective < ActiveRecord::Migration
  def change
    add_column :objectives, :threshold, :float
  end
end
