require 'test_helper'

class MigrationTest < CassandraObjectTestCase
  context "schemaless or not" do
    should "have the right schema version" do
      i = mock_invoice
      assert_equal 2, i.schema_version
    end
    
    should "not have a schema version if the class is schemaless" do
      Invoice.use_migrations = false
      assert_nil mock_invoice.schema_version
    end
  end
  
  test " a new invoice should have an empty gst_number" do
    assert_equal nil, mock_invoice.gst_number
  end
  
  context "schemaless or not" do
    should "fetch and update an old invoice" do
      key = Invoice.next_key.to_s
      connection.insert(Invoice.column_family, key, {"schema_version"=>"1", "number"=>"200", "total"=>"150.35"})
      
      invoice = Invoice.get(key)
      assert_equal 2, invoice.schema_version
      assert_equal 150.35, invoice.total
    end
    
    should "fetch and nullify the schema if the class has been changed to not have a schema" do
      Invoice.use_migrations = false
      key = Invoice.next_key.to_s
      connection.insert(Invoice.column_family, key, {"schema_version"=>"1", "number"=>"200", "total"=>"150.35"})
      
      invoice = Invoice.get(key)
      assert_nil invoice.schema_version
    end
  end
end