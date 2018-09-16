class ShareClassAccountToShareClassCount < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :share_class_account
    add_column :users, :share_class_count, :integer, default: 0
  end
end
