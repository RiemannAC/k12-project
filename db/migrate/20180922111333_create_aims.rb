class CreateAims < ActiveRecord::Migration[5.1]
  def change
    create_table :aims do |t|
      t.string :name
      t.string :status
      t.timestamps
    end
  end
end
