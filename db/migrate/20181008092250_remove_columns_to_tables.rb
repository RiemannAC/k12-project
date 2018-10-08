class RemoveColumnsToTables < ActiveRecord::Migration[5.1]
  def change
    remove_column :lessons, :topic_id
    remove_column :lessons, :subject_id
  end
end
