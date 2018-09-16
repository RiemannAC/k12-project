class CreateMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :materials do |t|
      t.string :mtrial_folder_name
      t.integer :subject_id

      t.timestamps
    end
  end
end
