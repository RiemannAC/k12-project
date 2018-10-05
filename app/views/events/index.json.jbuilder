json.array!(@user,@events) do |event|
  json.extract! event, :id ,:start,:end,:title,:created_at,:updated_at
  json.start event.start_time
  json.end event.end_time
  json.url user_event_url(event, format: :html)
  json.update_url user_event_path(event, method: :patch)
  json.edit_url edit_user_event_path(event)
  json.title event.title
  json.id event.id
end

#json.array! @events, partial: 'events/event', as: :event
