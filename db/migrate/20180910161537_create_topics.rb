class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.string :title, limit:10
      t.timestamps
    end
  end
end
