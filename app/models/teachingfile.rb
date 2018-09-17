#  == Schema Information
#
#  Table names : teachingfiles
#
#  id            :integer     not null, primary key
#  name          :string
#  attachment    :string
#  created_at    :datetime    not null
#  updated_at    :datetime    not null
#
#  material_id   :integer
#  plan_id       :integer
#  topic_id      :integer

class Teachingfile < ApplicationRecord
  belongs_to :plan
  #belongs_to :topic
  belongs_to :material
end
