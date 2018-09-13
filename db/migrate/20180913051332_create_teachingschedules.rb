class CreateTeachingschedules < ActiveRecord::Migration[5.1]
  def change
    create_table :teachingschedules do |t|
      t.string :theme ,limit:10
      t.string :target, limit:20
      t.string :feedback
      t.boolean :loading
      t.integer :classroom_id
      t.timestamps
    end
  end
end
