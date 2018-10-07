class AddClassroomIdToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons,:classroom_id,:integer
  end
end
