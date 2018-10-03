# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.

#這裡的每一個tag後面不能加逗號“，”
Rails.application.config.assets.precompile += %w( js/vendor/jquery.min.js
js/vendor/moment.min.js
js/vendor/bootstrap.min.js 
js/vendor/fullcalendar.js 
js/events.js 
js/calendar.js 
calendar/calendar-style.css 
calendar/fullcalendar.css 
calendar/bootstrap.min.css 
admin.js admin.css  )
