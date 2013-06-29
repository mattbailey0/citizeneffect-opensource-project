class FeaturedMediaAssociation < ActiveRecord::Base
  belongs_to :project
  belongs_to :featured_media, :polymorphic => true
  
  accepts_nested_attributes_for :featured_media, :reject_if => lambda { |attrs|
    self.reject_featured_media_attributes?(attrs)
  }
  
  acts_as_list :scope => :project
  
  def self.reject_featured_media_attributes?(attrs)
    attrs.andand["photo"].blank? && attrs.andand["url"].blank? && attrs.andand["title"].blank? && 
      attrs.andand["description"].blank?
  end
  
  def build_featured_media(attributes = {})
    klass = attributes.delete("type")
    raise "unknown media type" if klass.blank?
    self.featured_media = klass.constantize.new(attributes)
  end
  
end
