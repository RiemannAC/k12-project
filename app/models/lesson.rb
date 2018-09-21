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

  # def semester
  #   [ Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31),
  #    Time.new(Time.now.year + 1,2,1)..Time.new(Time.now.year + 1,6,30) ]
  # end

  SEMESTER = [ Time.new(Time.now.year,7,1)..Time.new(Time.now.year + 1,1,31),
     Time.new(Time.now.year + 1,2,1)..Time.new(Time.now.year + 1,6,30) ]
  # [0] => 上學期 range，[0].first => 開學，[0].end => 寒假
  # [1] => 下學期 range，[1].first => 開學，[1].end => 暑假

end
