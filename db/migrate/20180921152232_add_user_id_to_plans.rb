class AddUserIdToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans,:user_id,:integer
  end
end
