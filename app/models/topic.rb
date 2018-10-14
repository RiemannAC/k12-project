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

  ###lesson不再直接屬於topic , 所以這行要刪掉，不然會出現ActiveRecord::StatementInvalid (SQLite3::SQLException: no such column: lessons.topic_id: SELECT "lessons".* FROM "lessons" WHERE "lessons"."topic_id" = ?)
  #has_many :lessons, dependent: :destroy

  belongs_to :classroom,optional: true

  has_many :addfiles, dependent: :destroy 
  # topic 刪掉， addfile 上也不會有檔案，但 teachingfiles上的應保留
  has_many :added_files, through: :addfiles, source: :teachingfile

  has_many :aims,dependent: :destroy
end
