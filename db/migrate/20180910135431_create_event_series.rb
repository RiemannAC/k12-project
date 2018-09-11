class CreateEventSeries < ActiveRecord::Migration[5.1]
  def change
    create_table :event_series do |t|
      t.string   :type, default: "subject"
      t.string   :title, default: "未分類"
      t.string   :grade, default:"", null:false, limit: 8
      t.string   :class, default:"", null:false, limit: 8
      t.integer  :students, default: 0
      t.string   :color, default: "blue", null:false
      t.integer  :frequency, default: 1
      t.string   :period, default: "monthly"
      t.datetime :starttime
      t.datetime :endtime
      t.boolean  :all_day, default: false
      t.integer  :users_id

      t.timestamps
    end

    add_index :event_series, :users_id, unique: true
  end
end
