class AddColumnsToSubjects < ActiveRecord::Migration[5.1]
  def change
    remove_column :subjects, :name, :string
    remove_column :subjects, :classroom, :string
    add_column :subjects, :name, :string, default: "未分類"
    add_column :subjects, :grade, :string, default: ""
    add_column :subjects, :classroom, :string, default: ""
    add_column :subjects, :students, :integer, default: 0
    add_column :subjects, :event_type, :string, null: false, default: "lesson"
    add_column :subjects, :start_time, :datetime
    add_column :subjects, :end_time, :datetime
    add_column :subjects, :color, :string, default: "blue"
    add_column :subjects, :frequency, :integer, default: 1
    add_column :subjects, :period, :string, default: "weekly"
    add_column :subjects, :all_day, :boolean, default: false
  end
end
