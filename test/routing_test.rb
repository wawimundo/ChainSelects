require "#{File.dirname(__FILE__)}/test_helper"

class RoutingTest < Test::Unit::TestCase

  def setup
    ActionController::Routing::Routes.draw do |map|
      map.chain_selects
    end
  end

  def test_chain_selects_route
    assert_recognition :get, "/chain_selects/query", :controller => "chain_selects_controller", :action => "query"
  end

  private

    def assert_recognition(method, path, options)
      result = ActionController::Routing::Routes.recognize_path(path, :method => method)
      assert_equal options, result
    end
end