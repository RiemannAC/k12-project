class Teachingschedule < ApplicationRecord
  validates :theme, length: { maximum: 10, message: "theme can be allowed at most 10 words" }
  validates :target, length: { maximum: 20, message: "target can be allowed at most 20 words" }

  belongs_to :classroom
end
