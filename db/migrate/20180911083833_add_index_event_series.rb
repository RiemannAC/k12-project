class AddIndexEventSeries < ActiveRecord::Migration[5.1]
  def change
    add_column :event_series, :user_id, :integer
    add_index :event_series, :user_id, unique: true
  end
end
