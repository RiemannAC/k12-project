

json.array!(@user,@events) do |event|
  json.extract! event, :id ,:start,:end,:title,:created_at,:updated_at
  json.start event.start_time
  json.end event.end_time
  json.url user_event_url(event, format: :html)
end

#json.array! @events, partial: 'events/event', as: :event