#  == Schema Information
#
#  Table names : plans
#
#  id               :integer     not null, primary key
#  plan_folder_name :string
#  created_at       :datetime    not null
#  updated_at       :datetime    not null
#
#  subject_id       :integer

class Plan < ApplicationRecord
  belongs_to :subject
  has_many :teachingfiles
end
