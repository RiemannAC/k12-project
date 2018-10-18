class FixPgIssue < ActiveRecord::Migration[5.1]
  def change
    add_column :topics,:start_time, :datetime
    add_column :topics,:end_time, :datetime
    remove_column :topics, :set_week
    remove_column :topics, :file_upload
    remove_column :teachingfiles, :topic_id
  end
end
