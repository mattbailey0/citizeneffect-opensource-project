module ApiModelHelper
  
  def self.included(base)
    unless defined? base::READ_WRITE_FIELDS && base::READ_ONLY_FIELDS
      raise "to include ApiModelHelper READ_WRITE_FIELDS and READ_ONLY_FIELDS must be defined."
    end
    
    base.alias_method_chain :to_xml,  :api
    base.alias_method_chain :to_json, :api
    base.validate :all_items_belong_to_this_account
    
    base.attr_accessible *base::READ_WRITE_FIELDS
    accessible_fields = base::READ_WRITE_FIELDS

    # PRIVATE_READ_WRITE_FIELDS is for fields that need to be attr_accessible
    # but not exposed via API
    if base.constants.include? "PRIVATE_READ_WRITE_FIELDS"
      base.attr_accessible *base::PRIVATE_READ_WRITE_FIELDS

      accessible_fields << base::PRIVATE_READ_WRITE_FIELDS
      accessible_fields.flatten
    end

    accessible_fields.each do |field|
      field = field.to_s
      next unless field =~ /_id$/
      base.attr_accessible field.gsub(/_id$/,'')
    end
  end
  
  def all_items_belong_to_this_account
    return true unless defined? self.class::ACCOUNT_FIELDS_TO_CHECK
    self.class::ACCOUNT_FIELDS_TO_CHECK.each do |field|
      self.validate_item_belongs_to_account(field)
    end
  end
  
  def validate_item_belongs_to_account(field)
    item = self.send(field.to_s.gsub(/_id$/,''))
    if self.send(field) && (item.blank? || item.account_id != self.account_id)
      self.errors.add(field, "is invalid.")
    end
  end
  
  def to_xml_with_api(options = {})
    default_options = { }
    default_options[:only]    = self.class::READ_WRITE_FIELDS + self.class::READ_ONLY_FIELDS
    default_options[:methods] = self.class::API_METHODS if defined? self.class::API_METHODS
    options = options.dup
    options.reverse_merge!(default_options)
    self.to_xml_without_api(options)
  end
  
  def to_json_with_api(options = {})
    default_options = { }
    default_options[:only]    = self.class::READ_WRITE_FIELDS + self.class::READ_ONLY_FIELDS
    default_options[:methods] = self.class::API_METHODS if defined? self.class::API_METHODS
    options = options.dup
    options.reverse_merge!(default_options)
    self.to_json_without_api(options)
  end

end
