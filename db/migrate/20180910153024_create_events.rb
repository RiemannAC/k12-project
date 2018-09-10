class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string   :title, default: "未分類"
      t.datetime :starttime
      t.datetime :endtime
      t.boolean  :all_day, default: false
      t.text     :description
      t.string   :image, default: "", null:false
      t.string   :color, default: "green", null:false
      t.string   :rate, default: "fair", null:false
      t.string   :goal, default: "", null:false
      t.string   :feedback_title, default: "", null:false
      t.text     :feedback_comment, default: "", null:false
      t.integer  :event_series_id

      t.timestamps
    end

    add_index :events, :event_series_id, unique: true
  end
end
