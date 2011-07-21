require 'test_helper'

class AttributesTest < CassandraObjectTestCase
  setup do
    @manager = AttributesManager.new
  end
  
  should "set string value" do
    @manager.str = "test"
    assert_equal "test", @manager.str
  end
  
  context "boolean attribute" do
    setup do
      @manager.bool = true
    end
    
    should "set boolean value" do
      assert_equal true, @manager.bool
    end

    should "save boolean value" do
      assert @manager.save
    end

    should "retrieve boolean value" do
      assert @manager.save
      manager = AttributesManager.get(@manager.key)
      assert_equal @manager.bool, manager.bool
    end
  end
end