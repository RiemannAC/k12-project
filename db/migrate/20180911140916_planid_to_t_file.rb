class PlanidToTFile < ActiveRecord::Migration[5.1]
  def change
    add_column :teachingfiles,:material_id,:integer
    add_column :teachingfiles,:plan_id,:integer
  end
end
