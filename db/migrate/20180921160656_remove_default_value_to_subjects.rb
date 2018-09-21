class RemoveDefaultValueToSubjects < ActiveRecord::Migration[5.1]
  def change
    remove_column :subjects, :name, :string
    add_column :subjects, :name, :string
  end
end
