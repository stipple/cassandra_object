module CassandraObject
  class Cursor
    def initialize(target_class, column_family, key, super_column, options={})
      @target_class  = target_class
      @column_family = column_family
      @key           = key.to_s
      @super_column  = super_column
      @options       = options
      @validators    = []
    end
    
    def find(number_to_find=nil)
      limit       = number_to_find || 100
      objects     = CassandraObject::Collection.new
      out_of_keys = false

      if start_with = @options[:start_after]
        limit += 1
      else
        start_with = nil
      end
      
      while !out_of_keys && (number_to_find.nil? || objects.size < number_to_find)
        index_results = connection.get(@column_family, @key, @super_column, :count=>limit,
                                                                            :start=>start_with,
                                                                            :reversed=>@options[:reversed])
                                                                            
                                    
                                                                                                                      
        out_of_keys  = index_results.size < limit

        if !start_with.blank?
          index_results.delete(start_with)
        end
        
        keys = index_results.keys
        values = index_results.values
        
        missing_keys = []
        
        results = values.empty? ? {} : @target_class.multi_get(values)

        results.each do |(key, result)|
          if result.nil?
            missing_keys << key
          end
        end
        
        unless missing_keys.empty?
          values_hash = {}
          index_results.each do |key, value|
            values_hash[value] = key
          end
          @target_class.multi_get(missing_keys, :quorum=>true).each do |(key, result)|
            index_key = values_hash[key]
            if result.nil?
              remove(index_key)
              results.delete(key)
            else
              results[key] = result
            end
          end
        end
        results.values.each do |o|
          if @validators.all? {|v| v.call(o)}
            objects << o
          else
            remove(index_results[o.key])
          end
        end

        start_with = objects.last_column_name = keys.last
        limit = number_to_find.nil? ? 100 : (number_to_find - results.size) + 1
        
      end

      return objects
    end
    
    def connection
      @target_class.connection
    end
    
    def remove(index_key)
      connection.remove(@column_family, @key, @super_column, index_key)
    end
    
    def validator(&validator)
      @validators << validator
    end
  end
end
