require 'test_helper'

class ChainSelectsTest < Test::Unit::TestCase
  load_schema
  
  class Manufacturer < ActiveRecord::Base
  end
  
  class Brand < ActiveRecord::Base
  end
  
  class MakeModel < ActiveRecord::Base
  end
  
  def test_schema_has_loaded_correctly
    assert_equal [], Manufacturer.all
    assert_equal [], Brand.all
    assert_equal [], MakeModel.all
  end
end