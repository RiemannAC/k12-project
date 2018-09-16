class AddTeachscheduleIdInAimModel < ActiveRecord::Migration[5.1]
  def change
    add_column :aims,:teachingschedule_id,:integer
  end
end
