#  == Schema Information
#
#  Table names : subjects
#
#  id         :integer     not null, primary key
#  name       :string
#  classroom  :string#
#  created_at :datetime    not null
#  updated_at :datetime    not null
#
#  project_id

class Subject < ApplicationRecord
  belongs_to :project
  has_many :plans
  has_many :materials
  has_many :topics
end
