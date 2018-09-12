class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :title,limit:15
      t.integer :topic_id
      t.timestamps
    end
  end
end
