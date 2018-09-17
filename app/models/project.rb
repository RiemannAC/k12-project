#  == Schema Information
#  
#  Table names : projects
#
#  id         :integer     not null, primary key
#  start_week :datetime
#  end_week   :datetime
#  created_at :datetime    not null
#  updated_at :datetime    not null
#
#  user_id    :integer     

class Project < ApplicationRecord
  belongs_to :user, optional: true
  has_many :subjects, dependent: :destroy
end
