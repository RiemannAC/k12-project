class AddColumnsToLessons < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :grade, :string
    add_column :lessons, :room, :string
    remove_column :lessons, :classroom
  end
end
