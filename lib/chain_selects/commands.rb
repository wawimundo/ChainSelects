require 'rails_generator'
require 'rails_generator/commands'

module ChainSelects #:nodoc:
  module Generator #:nodoc:
    module Commands #:nodoc:
      module Create
        def chain_selects_route
          logger.route "map.chain_selects"
          look_for = 'ActionController::Routing::Routes.draw do |map|'
          
          unless options[:pretend]
            gsub_file('config/routes.rb', /(#{Regexp.escape(look_for)})/mi){|match| "#{match}\n map.chain_selects\n"}
          end
        end
      end
      
      module Destroy
        def chain_selects_route
          logger.route "map.chain_selects"
          gsub_file 'config/routes.rb', /\n.+?map\.chain_selects/mi, ''
        end
      end
      
      module List
        def chain_selects_route 
        end  
      end
      
      module Update
        def chain_selects_route 
        end
      end
    end
  end
end

Rails::Generator::Commands::Create.send  :include, ChainSelects::Generator::Commands::Create
Rails::Generator::Commands::Destroy.send  :include, ChainSelects::Generator::Commands::Destroy
Rails::Generator::Commands::List.send  :include, ChainSelects::Generator::Commands::List
Rails::Generator::Commands::Update.send  :include, ChainSelects::Generator::Commands::Update 