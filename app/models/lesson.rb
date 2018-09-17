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

  # validate :validate_timings
  # 現有資料格式套用 simple_calendar，但 simple_calendar view 沒有 endtime 輸入，暫時不用驗證


  REPEATS = [
              "Does not repeat",
              "Daily"          ,
              "Weekly"         ,
              "Monthly"        ,
              "Yearly"         
  ]

  def validate_timings
    if (starttime >= endtime) and !all_day
      errors[:base] << "Start Time must be less than End Time"
    end
  end

  def update_lessons(lessons, lesson)
    lessons.each do |l|
      begin 
        st, et = l.start_time, l.end_time
        l.attributes = lesson
        if subject.period.downcase == 'monthly' or subject.period.downcase == 'yearly'
          n_st = DateTime.parse("#{l.start_time.hour}:#{l.start_time.min}:#{l.start_time.sec}, #{l.start_time.day}-#{st.month}-#{st.year}")  
          n_et = DateTime.parse("#{l.end_time.hour}:#{l.end_time.min}:#{l.end_time.sec}, #{l.end_time.day}-#{et.month}-#{et.year}")
        else
          n_st = DateTime.parse("#{l.start_time.hour}:#{l.start_time.min}:#{l.start_time.sec}, #{st.day}-#{st.month}-#{st.year}")  
          n_et = DateTime.parse("#{l.end_time.hour}:#{l.end_time.min}:#{l.end_time.sec}, #{et.day}-#{et.month}-#{et.year}")
        end
      rescue
        n_st = n_et = nil
      end
      if n_st and n_et
        l.start_time, l.end_time = n_st, n_et
        l.save
      end
    end

    subject.attributes = lesson
    subject.save
  end
end
