#  == Schema Information
#
#  Table names : subjects
#
#  id         :integer     not null, primary key
#  name       :string
#  classroom  :string#
#  created_at :datetime    not null
#  updated_at :datetime    not null
#
#  project_id

class Subject < ApplicationRecord
  attr_accessor :commit_button # non-db attr 不要放 db arrt 會阻止寫入，而且不會報錯 

  belongs_to :user, optional: true
  #has_many :classrooms, dependent: :destroy
  has_and_belongs_to_many :classrooms

  has_many :plans
  has_many :materials

  validates_presence_of :name

  GRADE = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

  SUBJECT = ["國文", "英文", "數學", "社會", "自然", "生活科技", "藝術", "音樂", "體育", "班級經營", "家政", "健康教育", "其他"]

end
