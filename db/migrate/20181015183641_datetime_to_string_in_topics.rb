class DatetimeToStringInTopics < ActiveRecord::Migration[5.1]
  def change
    change_column :topics, :start_time, :string
    change_column :topics, :end_time, :string
  end
end
