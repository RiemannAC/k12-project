class Classroom < ApplicationRecord
  #belongs_to :subject, optional: true
  has_and_belongs_to_many :subjects

  has_many :lessons, dependent: :destroy

  validates_presence_of :name, :grade, :room

  GRADE = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
end