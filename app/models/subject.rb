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
  belongs_to :project
  has_many :plans
  has_many :materials
  has_many :topics, dependent: :destroy
  attr_accessor :name, :commit_button

  # 回呼重覆生成所需 lesson  
  validates_presence_of :frequency, :period, :start_time, :end_time
  validates_presence_of :name

  after_create :create_events_until_end_time
  
  def create_events_until_end_time(end_time=END_TIME)
    st = start_time
    et = end_time
    p = repeated_period(period)
    n_st, n_et = st, et
    
    while frequency.send(p).from_now(st) <= end_time
      topic = self.topics.create( name: "未分類" )
      topic.lessons.create(:name => name, :start_time => st, :end_time => et)
      n_st = st = frequency.send(p).from_now(st)
      n_et = et = frequency.send(p).from_now(et)
      
      if period.downcase == 'monthly' or period.downcase == 'yearly'
        begin 
          n_st = DateTime.parse("#{start_time.hour}:#{start_time.min}:#{start_time.sec}, #{start_time.day}-#{st.month}-#{st.year}")  
          n_et = DateTime.parse("#{end_time.hour}:#{end_time.min}:#{end_time.sec}, #{end_time.day}-#{et.month}-#{et.year}")
        rescue
          n_st = n_et = nil
        end
      end
    end
  end
  
  def repeated_period(period)
    case period
      when 'Daily'
      p = 'days'
      when "Weekly"
      p = 'weeks'
      when "Monthly"
      p = 'months'
      when "Yearly"
      p = 'years'
    end
    return p
  end
end
