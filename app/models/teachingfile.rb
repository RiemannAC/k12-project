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
  mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.
  validates_presence_of :name

  belongs_to :plan, optional: true
  belongs_to :topic, optional: true
  belongs_to :material, optional: true

end
