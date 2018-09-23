class ChangeDatabaseTopicModel < ActiveRecord::Migration[5.1]
  def change
    remove_column :topics,:aim,:string
    remove_column :topics,:accessment,:integer
    remove_column :topics,:feedback_title,:string
    rename_column :topics,:feedback_content,:feedback
  end
end
 