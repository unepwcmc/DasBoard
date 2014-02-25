class ObjectiveThresholdToFloat < ActiveRecord::Migration
  def change
    change_column :objectives, :threshold, :float
  end
end
