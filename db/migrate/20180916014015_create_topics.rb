class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.string :name
      t.datetime :set_week
      t.string :aim
      t.integer :accessment
      t.string :file_upload
      t.string :feedback_title
      t.text :feedback_content

      t.integer :subject_id

      t.timestamps
    end
  end
end
