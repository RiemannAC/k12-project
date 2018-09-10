class Topic < ApplicationRecord
  validates_presence_of :title
  validates :title, length: { maximum: 10, message: "topic name could be at most 10 words" }

  has_many :plans,dependent: :destroy
  has_many :materials,dependent: :destroy
end
