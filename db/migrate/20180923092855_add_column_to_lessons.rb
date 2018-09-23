class AddColumnToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons,:event_type,:string, default: "lesson"
  end
end
