class ChainSelectsRouteGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.chain_selects_route
    end
  end
end 