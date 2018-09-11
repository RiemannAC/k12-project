class RenameColumnEventSeries < ActiveRecord::Migration[5.1]
  def change
    rename_column :event_series, :type, :event_type
    rename_column :event_series, :class, :class_name
  end
end
