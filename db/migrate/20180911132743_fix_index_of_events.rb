class FixIndexOfEvents < ActiveRecord::Migration[5.1]
  # 一對多不可設定 unique index
  def change
    remove_index :events, :event_series_id if index_exists? :events, :event_series_id 
    add_index :events, :event_series_id
  end
end
