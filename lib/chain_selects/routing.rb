module ChainSelects #:nodoc:
  module Routing #:nodoc:
    module MapperExtensions
      def chain_selects
        @set.add_route("/chain_selects/query/:id", {:controller => "chain_selects", :action => "query"})
        @set.add_route("/chain_selects/query", {:controller => "chain_selects", :action => "query"})
      end
    end
  end
end

ActionController::Routing::RouteSet::Mapper.send :include, ChainSelects::Routing::MapperExtensions