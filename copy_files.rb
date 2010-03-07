ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../'
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))

# Taken from ActiveScaffold's install_assets.rb

def copy_files(source_path, destination_path, directory)
  source, destination = File.join(directory, source_path), File.join(Rails.root, destination_path)
  FileUtils.mkdir(destination) unless File.exist?(destination)
  FileUtils.cp_r(Dir.glob(source+'/*.*'), destination)
end