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
  
  context "when 20 items exist" do
    setup do
      dob = Date.parse('1978/12/15')
      20.times do |i|
        Customer.create :first_name => "Michael",
                        :last_name => i.to_s,
                        :date_of_birth => dob
      end
    end
    
    should "page without duplication of items" do
      page1 = Customer.page('', :limit => 5)
      page2 = Customer.page(page1.last.key.to_s, :limit => 8)
      
      assert_equal 5, page1.length
      assert_equal 8, page2.length
      
      assert_equal 0, (page1 & page2).length
    end
  end
end
