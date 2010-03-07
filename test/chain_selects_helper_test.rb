require File.dirname(__FILE__) + '/test_helper.rb'
include ChainSelectsHelper

class ChainSelectsHelperTest < Test::Unit::TestCase
  def test_constantizing
    assert_equal Manufacturer, constantize_model("Manufacturer")
  end
end