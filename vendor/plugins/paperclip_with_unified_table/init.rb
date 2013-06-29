module UnifiedAttachmentAssociationMethods
  def generate_flavor(association_id)
    "#{self.name}_#{association_id.to_s}"
  end
  
  def has_one_unified_attachment(association_id, options = {})
    flavor = self.generate_flavor(association_id)
    default_options = { 
      :as          => :uploadable,
      :class_name  => "UnifiedUpload",
      :foreign_key => "uploadable_id", 
      :conditions  => {:flavor => flavor}          
    }

    # gotta dupe before we merge conditions
    options = options.dup.symbolize_keys
    
    if options[:conditions]
      options[:conditions] = options[:conditions].dup.symbolize_keys
      options[:conditions].reverse_merge!(default_options[:conditions])
    end        

    options.reverse_merge!(default_options)        
    tmp = has_one(association_id, options)
    self.unify_has_one_attachments(association_id)
    tmp
  end

  def has_many_unified_attachments(association_id, options = {})
    flavor = self.generate_flavor(association_id)
    default_options = { 
      :as          => :uploadable,
      :class_name  => "UnifiedUpload",
      :foreign_key => "uploadable_id", 
      :conditions  => {:flavor => flavor},
      :before_add  => Proc.new {|parent, item| item.flavor = flavor }
    }

    # we want these to stack
    if options[:before_add] && options[:before_add].is_a?(Array)
      options[:before_add] << default_options[:before_add] 
    elsif options[:before_add]
      options[:before_add] = [options[:before_add]]
      options[:before_add] << default_options[:before_add] 
    end 
    
    # gotta dupe before we merge conditions
    options = options.dup.symbolize_keys
    
    if options[:conditions]
      options[:conditions] = options[:conditions].dup.symbolize_keys
      options[:conditions].reverse_merge!(default_options[:conditions])
    end        

    options.reverse_merge!(default_options)
    
    has_many(association_id, options)
  end
  
  def unify_has_one_attachments(association_id)
    flavor = self.generate_flavor(association_id)
    module_eval do 
      alias :"ar_#{association_id}=" :"#{association_id}="
      alias :"ar_build_#{association_id}" :"build_#{association_id}"
    end
      
    define_method("#{association_id}=") do |*params|
      unless params.first.kind_of?(UnifiedUpload)
        params[0] = UnifiedUpload.new(:content => params[0])
      end
      params.first.flavor = flavor
      self.send("ar_#{association_id}=", *params)
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

ActiveRecord::Base.extend(UnifiedAttachmentAssociationMethods)
