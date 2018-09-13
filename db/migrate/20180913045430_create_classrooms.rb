class CreateClassrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :classrooms do |t|
      t.string :name,limit:8
      t.integer :topic_id
      t.timestamps
    end
  end
end
