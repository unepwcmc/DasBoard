class AddNameAndTimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :name, :string
    add_column :events, :date, :datetime
  end
end
