class AddDefaultThresholdValue < ActiveRecord::Migration
  def change
    change_column :objectives, :threshold, :float, :default => 0.0
  end
end
