class AddTopcIdInAimModel < ActiveRecord::Migration[5.1]
  def change
    add_column :aims,:topic_id,:integer
  end
end
