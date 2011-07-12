require 'test_helper'

class AssociationDeleteTest < CassandraObjectTestCase
  context "A model with a single associated object" do
    setup do
      @customer = Customer.create :first_name    => "Michael",
                                  :last_name     => "Koziarski",
                                  :date_of_birth => Date.parse("1980/08/15")

      @invoice = mock_invoice
      @customer.paid_invoices << @invoice
    end
    
    should "be empty when cleared" do
      @customer.paid_invoices.clear!
      
      assert_equal [], @customer.paid_invoices.to_a 
    end
    
    should "still support new associations when cleared" do
      @customer.paid_invoices.clear!
      @customer.paid_invoices << @invoice
      
      assert_equal [@invoice], @customer.paid_invoices.to_a 
    end
  end
  
  context "A model with a reverse association with a single object" do
    setup do
      @customer = Customer.create :first_name    => "Michael",
                                  :last_name     => "Koziarski",
                                  :date_of_birth => Date.parse("1980/08/15")
      
      @invoice = mock_invoice
      @customer.invoices << @invoice
    end
    
    should "have set the inverse" do
      assert_equal @customer, @invoice.customer
    end
    
    should "raise an exception when trying to clear a reversed association" do
      assert_raise(CassandraObject::AssociationClearError) do
        @customer.invoices.clear!
      end
    end
  end
end
