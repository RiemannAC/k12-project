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
  belongs_to :subject
  belongs_to :subject_tag
  has_many :teachingfiles
end
