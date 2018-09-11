class FixIndexOfEventSeries < ActiveRecord::Migration[5.1]
  # 一對多不可設定 unique index
  def change
    remove_index :event_series, :user_id if index_exists? :event_series, :user_id
    add_index :event_series, :user_id
  end
end
