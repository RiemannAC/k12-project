class SubjectTag < ApplicationRecord
  has_many :plans, dependent: :destroy
  has_many :materials, dependent: :destroy
end
