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
  belongs_to :user, optional: true
  has_many :topics, dependent: :destroy

  has_many :plans
  has_many :materials

  validates_presence_of :name, :classroom, :grade

  attr_accessor :name, :commit_button

end
