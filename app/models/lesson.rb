#  == Schema Information
#
#  Table names : lessons
#
#  id            :integer     not null, primary key
#  name          :string
#  start_time    :datetime
#  end_time      :datetime
#  created_at    :datetime    not null
#  updated_at    :datetime    not null
#
#  topic_id      :integer

class Lesson < ApplicationRecord
  attr_accessor :period, :frequency, :commit_button
  validates_presence_of :name

  belongs_to :topic, optional: true

  REPEATS = [ "Does not repeat", "Repeat weekly" ]

end
