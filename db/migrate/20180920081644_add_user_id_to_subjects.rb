class AddUserIdToSubjects < ActiveRecord::Migration[5.1]
  def change
    add_column :subjects,:user_id,:integer
  end
end
