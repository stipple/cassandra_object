require 'cassandra'
require 'set'
require 'cassandra_object/attributes'
require 'cassandra_object/dirty'
require 'cassandra_object/persistence'

if CassandraObject.old_active_support
  require 'cassandra_object/legacy_callbacks'
else
  require 'cassandra_object/callbacks'
end

require 'cassandra_object/validation'
require 'cassandra_object/identity'
require 'cassandra_object/indexes'
require 'cassandra_object/serialization'
require 'cassandra_object/associations'
require 'cassandra_object/migrations'
require 'cassandra_object/cursor'
require 'cassandra_object/collection'
require 'cassandra_object/types'
require 'cassandra_object/mocking'

module CassandraObject
  class Base
    class_attribute :connection
    class_attribute :connection_class
    class_attribute :use_migrations

    self.connection_class = Cassandra

    self.use_migrations = true
    
    module ConnectionManagement
      def establish_connection(*args)
        self.connection = connection_class.new(*args)
      end
    end
    extend ConnectionManagement

    module Naming
      def column_family=(column_family)
        @column_family = column_family
      end

      def column_family
        @column_family || name.pluralize
      end
    end
    extend Naming
    
    if CassandraObject.old_active_support
      def self.lookup_ancestors
        super.select { |x| x.model_name.present? }
      end
    end
    
    extend ActiveModel::Naming
    
    
    include Callbacks
    include Identity
    include Attributes
    include Persistence
    include Indexes
    include Dirty

    include Validation
    include Associations

    attr_reader :attributes
    attr_accessor :key

    include Serialization
    include Migrations
    include Mocking

    def initialize(attributes={})
      @key = attributes.delete(:key)
      @new_record = true
      @attributes = {}.with_indifferent_access
      self.attributes = attributes
      @schema_version = self.class.use_migrations ? self.class.current_schema_version : nil
    end
  end
end

require 'cassandra_object/type_registration'
