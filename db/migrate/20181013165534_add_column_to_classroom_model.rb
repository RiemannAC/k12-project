class AddColumnToClassroomModel < ActiveRecord::Migration[5.1]
  def change
    add_column :classrooms,:student,:integer,default: 0
  end
end
