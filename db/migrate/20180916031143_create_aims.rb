class CreateAims < ActiveRecord::Migration[5.1]
  def change
    create_table :aims do |t|
      t.string :title
      t.integer :assessment
      t.timestamps
    end
  end
end
