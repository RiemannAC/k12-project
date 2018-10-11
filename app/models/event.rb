class Event < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :start
  belongs_to :user
end
