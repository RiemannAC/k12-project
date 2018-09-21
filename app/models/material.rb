#  == Schema Information
#
#  Table names : materials
#
#  id                 :integer     not null, primary key
#  mtrial_folder_name :string
#  created_at         :datetime    not null
#  updated_at         :datetime    not null
#
#  subject_id    :integer

class Material < ApplicationRecord
  #belongs_to :subject
  validates_presence_of :mtrial_folder_name
  belongs_to :subject_tag
  belongs_to :user
  has_many :teachingfiles, dependent: :destroy
end
