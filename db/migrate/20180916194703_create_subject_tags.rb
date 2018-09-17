class CreateSubjectTags < ActiveRecord::Migration[5.1]
  def change
    create_table :subject_tags do |t|
      t.string :name
      t.timestamps
    end

    add_column :materials,:subject_tag_id,:integer
    add_column :plans,:subject_tag_id,:integer
  end
end
