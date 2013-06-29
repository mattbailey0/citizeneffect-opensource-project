module PaperclipWithUnifiedTable
  def self.included(klass)
    klass.extend ClassMethods
  end
  
  module ClassMethods
    def unify_attachments(association_id)
      module_eval do 
        alias :"ar_#{association_id}=" :"#{association_id}="
        alias :"ar_build_#{association_id}" :"build_#{association_id}"
      end
      
      define_method("#{association_id}=") do |*params|
        params.first.flavor = "#{self.class.name}_#{association_id.to_s}"
        self.send("ar_#{association_id}=", *params)
      end
      
      define_method("build_#{association_id}") do |*params|
        params << {} unless params.first
        params.first[:flavor] = "#{self.class.name}_#{association_id.to_s}"
        self.send("ar_build_#{association_id}", *params)
      end
    end
  end  
end
# PaperclipWithUnifiedTable
