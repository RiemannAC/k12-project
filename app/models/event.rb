class Event < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :start
  belongs_to :user
  # events_controller 35 行 unknow method start for event，抓不到 start 先用別名
  alias_attribute :start, :start_time
end
