require 'test_helper'

class PersistenceTest < CassandraObjectTestCase
  context "when 2 items exist" do
    def setup
      super
      Customer.create :first_name    => "Michael",
                      :last_name     => "Koziarski",
                      :date_of_birth => Date.parse("1980/08/15")
      Customer.create :first_name    => "Tom",
                      :last_name     => "Doe",
                      :date_of_birth => Date.parse("1988/08/08")
    end
    
    should "count" do
      assert_equal 2, Customer.count
    end
    
    context "when an item is deleted" do
      setup do
        Customer.remove(Customer.first.key)
      end

      should "not count deleted items" do
        assert_equal 1, Customer.count
      end
    end
    
    context "when all items are deleted" do
      setup do
        Customer.all.each { |c| Customer.remove(c.key) }
      end

      should "not count deleted items" do
        assert_equal 0, Customer.count
      end
    end
  end
end
