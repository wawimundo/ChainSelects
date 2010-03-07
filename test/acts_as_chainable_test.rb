require File.dirname(__FILE__) + '/test_helper.rb'

load_schema

class Manufacturer < ActiveRecord::Base
  acts_as_chainable :to => :brand, :root => true
end

class Brand < ActiveRecord::Base
  acts_as_chainable :to => :make_model, :from => :manufacturer
end

class MakeModel < ActiveRecord::Base
  acts_as_chainable :select_label => 'Model', :from => :brand
end

Manufacturer.create(:id => 2, :name => "Toyota")

class ActsAsChainableTest < Test::Unit::TestCase
  load_schema

  def test_blank_chain_drop_down_should_be_blank_array
    assert_equal [], Manufacturer.chain_drop_down
  end
end