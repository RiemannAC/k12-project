class FixFkEventSeries < ActiveRecord::Migration[5.1]
  # 移除外鍵設定錯誤-複數
  def change
    remove_column :event_series, :users_id
    remove_index :event_series, :users_id if index_exists? :event_series, :users_id
  end
end
