class CreateTtopics < ActiveRecord::Migration[5.1]
  def change
    create_table :ttopics do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
