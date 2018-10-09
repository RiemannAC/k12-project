class CreateJoinTableSubjectsClassrooms < ActiveRecord::Migration[5.1]
  def change
    create_join_table :subjects, :classrooms do |t|
      t.index :subject_id
      t.index :classroom_id
    end
  end
end
