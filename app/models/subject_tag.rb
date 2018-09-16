class SubjectTag < ApplicationRecord
  has_many :materials
  has_many :plans
end
