class CreateTeachingfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :teachingfiles do |t|
      t.string :name
      t.string :attachment
      t.integer :material_id
      t.integer :plan_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
