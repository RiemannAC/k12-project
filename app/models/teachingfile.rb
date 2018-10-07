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
  mount_uploader :attachments, AttachmentUploader # Tells rails to use this uploader for this model.
  serialize :attachments, JSON
  
  validates_presence_of :name

  belongs_to :plan, optional: true
  #belongs_to :topic
  belongs_to :material, optional: true
end
