require File.dirname(__FILE__) + '/copy_files'

# copy files from lib/public/* to the app/public

copy_files('./lib/public/images', 'public/images', '.')
copy_files('./lib/public/stylesheets', 'public/stylesheets', '.')