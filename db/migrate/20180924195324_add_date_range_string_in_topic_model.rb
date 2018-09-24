class AddDateRangeStringInTopicModel < ActiveRecord::Migration[5.1]
  def change
    add_column :topics,:start_time,:string
    add_column :topics,:end_time,:string
  end
end
