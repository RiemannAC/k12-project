class CreateMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :materials do |t|

      t.timestamps
    end
  end
end
