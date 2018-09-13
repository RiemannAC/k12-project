class Topic < ApplicationRecord
  validates_presence_of :name
  validates :name, length: { maximum: 10, message: "topic name could be at most 10 words" }

  has_many :plans,dependent: :destroy
  has_many :materials,dependent: :destroy
  has_many :classrooms,dependent: :destroy
end
