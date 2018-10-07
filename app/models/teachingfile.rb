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
  mount_uploaders :attachments, AttachmentUploader # Tells rails to use this uploader for this model.
  serialize :attachments, JSON
  
  validates_presence_of :name

  belongs_to :plan, optional: true
  #belongs_to :topic
  belongs_to :material, optional: true
  has_many :addfiles #teachingfile 刪掉，但 addfile 應該還要保留才對
  has_many :teachingfiles, through: :addfiles
end
