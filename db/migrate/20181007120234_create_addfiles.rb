class CreateAddfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :addfiles do |t|
      t.integer :topic_id
      t.integer :teachingfile_id
      t.timestamps
    end
  end
end
