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
  #before_action :authenticate_user!
  
  #belongs_to :subject
  validates_presence_of :plan_folder_name
  belongs_to :subject_tag
  belongs_to :user
  has_many :teachingfiles, dependent: :destroy
end
