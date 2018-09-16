class RenameAimModel < ActiveRecord::Migration[5.1]
  def change
    rename_column :aims,:assessment,:accessment
  end
end
