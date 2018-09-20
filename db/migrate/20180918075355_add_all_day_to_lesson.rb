class AddAllDayToLesson < ActiveRecord::Migration[5.1]
  def change
    add_column :lessons, :all_day, :boolean, default: false
  end
end
