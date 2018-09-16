class Teachingschedule < ApplicationRecord
  validates :theme, length: { maximum: 10, message: "theme can be allowed at most 10 words" }
  validates :target, length: { maximum: 20, message: "target can be allowed at most 20 words" }

  belongs_to :classroom

  has_many :aims
  accepts_nested_attributes_for :aims, 
  :allow_destroy => true,
  :reject_if => :all_blank, 
  :update_only => true
end
