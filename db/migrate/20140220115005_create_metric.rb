class CreateMetric < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :name
      t.json :data, :default => []
    end
  end
end
