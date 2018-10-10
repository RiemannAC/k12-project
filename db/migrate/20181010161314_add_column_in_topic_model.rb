class AddColumnInTopicModel < ActiveRecord::Migration[5.1]
  def change
    add_column :topics,:classroom_id,:integer
  end
end
