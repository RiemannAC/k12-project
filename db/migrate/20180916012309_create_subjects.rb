class CreateSubjects < ActiveRecord::Migration[5.1]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :classroom
      t.integer :project_id

      t.timestamps
    end
  end
end
