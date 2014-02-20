class CreateObjective < ActiveRecord::Migration
  def change
    create_table :objectives do |t|
      t.string :name
      t.integer :metric_id
      t.integer :project_id
      t.index :metric_id
      t.index :project_id
    end
  end
end
