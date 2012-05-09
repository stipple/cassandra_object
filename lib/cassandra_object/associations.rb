require 'cassandra_object/associations/one_to_many'
require 'cassandra_object/associations/one_to_one'

module CassandraObject
  module Associations
    extend ActiveSupport::Concern
    
    included do
      class_attribute :associations
      self.associations = {}
    end

    module ClassMethods
      def column_family_configuration
        super << {:Name=>"#{name}Relationships", :CompareWith=>"UTF8Type", :CompareSubcolumnsWith=>"TimeUUIDType", :ColumnType=>"Super"}
      end
      
      def association(association_name, options= {})
        klass = options[:unique] ? OneToOneAssociation : OneToManyAssociation
        self.associations.merge!({association_name => klass.new(association_name, self, options)})
      end
      
      def remove(key)
        begin
          connection.remove("#{name}Relationships", key.to_s)
        rescue Cassandra::AccessError => e
          raise e unless e.message =~ /Invalid column family/
        end
        super
      end
    end
  end
end
