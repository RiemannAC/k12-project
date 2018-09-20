class AddSubjectIdToLesson < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons,:subject_id,:integer
  end
end
