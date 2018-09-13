class Event < ApplicationRecord
  attr_accessor :period, :frequency, :commit_button
  alias_attribute :start_time, :starttime
  alias_attribute :end_time, :endtime
  alias_attribute :name, :title

  validates_presence_of :title
  # validate :validate_timings
  # 現有資料格式套用 simple_calendar，但 simple_calendar view 沒有 endtime 輸入，暫時不用驗證
  
  belongs_to :event_series
  
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
  
  def update_events(events, event)
    events.each do |e|
      begin 
        st, et = e.starttime, e.endtime
        e.attributes = event
        if event_series.period.downcase == 'monthly' or event_series.period.downcase == 'yearly'
          nst = DateTime.parse("#{e.starttime.hour}:#{e.starttime.min}:#{e.starttime.sec}, #{e.starttime.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.endtime.hour}:#{e.endtime.min}:#{e.endtime.sec}, #{e.endtime.day}-#{et.month}-#{et.year}")
        else
          nst = DateTime.parse("#{e.starttime.hour}:#{e.starttime.min}:#{e.starttime.sec}, #{st.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.endtime.hour}:#{e.endtime.min}:#{e.endtime.sec}, #{et.day}-#{et.month}-#{et.year}")
        end
      rescue
        nst = net = nil
      end
      if nst and net
        e.starttime, e.endtime = nst, net
        e.save
      end
    end
    
    event_series.attributes = event
    event_series.save
  end
end
