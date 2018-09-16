class CreateLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lessons do |t|
      t.string :name #想繼承 subject.name
      t.datetime :start_time
      t.datetime :end_time

      t.integer :topic_id

      t.timestamps
    end
  end
end
