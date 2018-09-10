class Material < ApplicationRecord
  validates_presence_of :title
  validates :title, length: { maximum: 15, message: "file name could be at most 15 words" }

  belongs_to :topic
end
