class Aim < ApplicationRecord
  validates_presence_of :title
  belongs_to :teachingschedule
end
