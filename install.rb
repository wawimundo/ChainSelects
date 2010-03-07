require File.dirname(__FILE__) + '/copy_files'

# copy files from lib/public/* to the app/public



directory = File.dirname(__FILE__)

copy_files('./lib/public/images', 'public/images', File.dirname(__FILE__))
copy_files('./lib/public/stylesheets', 'public/stylesheets', File.dirname(__FILE__))