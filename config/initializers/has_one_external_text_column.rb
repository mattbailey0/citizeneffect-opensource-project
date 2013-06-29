module ExternalTextColumnAssociationMethods
  attr_accessor :external_text_columns
  
  module InstanceMethods

    def write_attribute(*args, &block)
      raise "external text columns do not support write_attribute" if self.class.external_text_columns.andand.include? args.first.to_s
      super
    end
    
    def read_attribute(*args, &block)
      raise "external text columns do not support read_attribute" if self.class.external_text_columns.andand.include? args.first.to_s
      super
    end
    
  end
  
  def generate_external_text_column_flavor(association_id)
    "#{self.name}_#{association_id.to_s}"
  end
  
  def has_one_external_text_column(association_id, options = {})
    self.send(:include, InstanceMethods) unless self.included_modules.include? InstanceMethods
    
    flavor = self.generate_external_text_column_flavor(association_id)
    default_options = { 
      :as          => :column_owner,
      :class_name  => "ExternalTextColumn",
      :foreign_key => "column_owner_id", 
      :conditions  => {:flavor => flavor},
#       :dependent   => :destroy, # this breaks parent.destroy because that tries parent.ext_text_col.destroy
      :autosave    => true
    }

    # gotta dupe before we merge conditions
    options = options.dup.symbolize_keys
    
    if options[:conditions]
      options[:conditions] = options[:conditions].dup.symbolize_keys
      options[:conditions].reverse_merge!(default_options[:conditions])
    end        

    options.reverse_merge!(default_options)        
    tmp = has_one(association_id, options)
    self.unify_has_one_external_text_column(association_id)
    
    self.external_text_columns ||= []
    self.external_text_columns << association_id.to_s
    
    tmp
  end

  def unify_has_one_external_text_column(association_id)
    flavor = self.generate_external_text_column_flavor(association_id)
    module_eval do 
      alias :"ar_#{association_id}=" :"#{association_id}="
      alias :"ar_build_#{association_id}" :"build_#{association_id}"
      alias :"ar_#{association_id}" :"#{association_id}"
    end
      
    define_method("#{association_id}=") do |*params|
      current = self.send("ar_#{association_id}")
      if current.nil? || params.first.kind_of?(ExternalTextColumn)
        params[0] = ExternalTextColumn.new(:content => params[0]) unless params.first.kind_of?(ExternalTextColumn)
        params.first.flavor = flavor
        self.send("ar_#{association_id}=", *params)        
      else
        current.content = params[0]
      end
    end
    
    define_method("#{association_id}") do |*params|
      self.send("ar_#{association_id}").andand.content
    end
      
    define_method("build_#{association_id}") do |*params|
      params << {} unless params.first
      params.first[:flavor] = flavor
      self.send("ar_build_#{association_id}", *params)
    end
    
    define_method("create_#{association_id}") do |*params|
      params << {} unless params.first
      params.first[:flavor] = flavor
      self.send("ar_build_#{association_id}", *params)
    end
    
  end

end

ActiveRecord::Base.extend(ExternalTextColumnAssociationMethods)
