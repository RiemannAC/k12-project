class AddStatusToAim < ActiveRecord::Migration[5.1]
  def change
    add_column :aims,:status,:string
    remove_column :aims,:accessment,:interger
  end
end
