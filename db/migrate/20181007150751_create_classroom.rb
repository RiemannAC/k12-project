class CreateClassroom < ActiveRecord::Migration[5.1]
  def change
    create_table :classrooms do |t|
      t.string :name, null: false, default: ""
      t.string :grade, null: false, default: ""
      t.string :room, null: false, default: ""
      t.integer :subject_id

      t.timestamps
    end
  end
end
