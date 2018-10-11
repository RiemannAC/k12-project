class AddColumnInClassroomModel < ActiveRecord::Migration[5.1]
  def change
    add_column :classrooms,:user_id,:integer
  end
end
