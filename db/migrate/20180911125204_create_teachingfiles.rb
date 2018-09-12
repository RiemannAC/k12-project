class CreateTeachingfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :teachingfiles do |t|
      t.string :filename
      t.string :attachment
      t.timestamps
    end
  end
end
