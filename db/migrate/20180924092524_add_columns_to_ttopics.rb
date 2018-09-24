class AddColumnsToTtopics < ActiveRecord::Migration[5.1]
  def change
    add_column :ttopics,:subject_id,:integer
    add_column :ttopics, :feedback, :text
    add_column :ttopics, :file_upload, :string
  end
end
