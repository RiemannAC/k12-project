class ChangeTopicsTeachingfiles < ActiveRecord::Migration[5.1]
  def change
    change_column :topics, :start_time, :datetime
    change_column :topics, :end_time, :datetime
    remove_column :topics, :set_week
    remove_column :topics, :file_upload
    remove_column :teachingfiles, :topic_id
  end
end
