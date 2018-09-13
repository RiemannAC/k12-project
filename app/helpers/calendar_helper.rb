module CalendarHelper
  def calendar(date = Date.today, &block)
    CalendarHand.new(self, date, block).table
    # 與 simple_calendar /lib/calendar.rb 同名，故更名為 calendar_hand.rb
  end
end