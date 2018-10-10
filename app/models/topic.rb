#  == Schema Information
#
#  Table names : topics
#
#  id                :integer     not null, primary key
#  name              :string
#  set_week          :datetime
#  aim               :string
#  accessment        :integer
#  file_upload       :string
#  feedback_title    :string
#  feedback_content  :text
#  created_at        :datetime    not null
#  updated_at        :datetime    not null
#
#  subject_id        :integer

class Topic < ApplicationRecord
  belongs_to :subject, optional: true
  has_many :lessons, dependent: :destroy

  belongs_to :classroom,optional: true

  has_many :addfiles, dependent: :destroy 
  # topic 刪掉， addfile 上也不會有檔案，但 teachingfiles上的應保留
  has_many :added_files, through: :addfiles, source: :teachingfiles

  has_many :aims,dependent: :destroy
end
