class Classroom < ApplicationRecord
  validate_presence_of :name
  validates :name, length: { maximum: 8, message: "classroom can be allowed at most 8 words" }

  belongs_to :topic

  has_many :teachingschedules,dependent: :destroy 
end

