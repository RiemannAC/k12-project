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
  belongs_to :topic
end
