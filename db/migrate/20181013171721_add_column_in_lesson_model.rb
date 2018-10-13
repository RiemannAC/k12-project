class AddColumnInLessonModel < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons,:student,:integer,default: 0 
  end
end
