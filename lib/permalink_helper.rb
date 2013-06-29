module PermalinkHelper
  def self.included(klass)
    klass.extend ClassMethods
  end
  
  def to_param
    read_attribute(self.class.permalink_field)
  end
  
  module ClassMethods
    def find_one(id, options)
      conditions = " AND (#{sanitize_sql(options[:conditions])})" if options[:conditions]
      
      result = find_one_by_id(id, options, conditions) || find_one_by_permalink(id, options, conditions)
      if result
        result
      else
        raise ActiveRecord::RecordNotFound, "Couldn't find #{name} with ID Or Permalink=#{id}#{conditions}"
      end
    end
    
    def find_one_by_id(id, options, conditions)
      id_condition = "#{quoted_table_name}.#{connection.quote_column_name(primary_key)} = " +
        "#{quote_value(id,columns_hash[primary_key])}"
      
      options.update :conditions => "#{id_condition}#{conditions}"
      
      find_initial(options)
    end
    
    def find_one_by_permalink(permalink, options, conditions)
      permalink_condition = "#{quoted_table_name}.#{connection.quote_column_name(self.permalink_field)} = " +
        "#{quote_value(permalink, self.permalink_field)}"
      
      options.update :conditions => "#{permalink_condition}#{conditions}"
        
      find_initial(options)
    end
  end
end
