class Aim < ApplicationRecord
  validates_presence_of :name
  belongs_to :topic
end
