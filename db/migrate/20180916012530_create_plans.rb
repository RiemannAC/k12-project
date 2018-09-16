class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :plan_folder_name
      t.integer :subject_id

      t.timestamps
    end
  end
end
