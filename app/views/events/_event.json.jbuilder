
date_format = event.all_day_event? ? '%Y-%m-%d' : '%Y-%m-%dT%H:%M:%S'

json.id event.id
json.title event.title
json.start_time event.start_time.strftime(date_format)
json.end_time event.end_time.strftime(date_format)


json.update_url user_lessons_path
json.edit_url edit_event_path(event)