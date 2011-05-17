# ChainSelects
require 'chain_selects/acts_as_chainable'
require 'chain_selects/routing'
require 'chain_selects/commands'

%w{models controllers helpers}.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.autoload_paths << path
  ActionController::Base.helper ChainSelects
end