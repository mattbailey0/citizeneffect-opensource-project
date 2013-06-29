class Campaign < ActiveRecord::Base
  include PermalinkHelper

  has_many :project_campaign_associations
  has_many :projects, :through => :project_campaign_associations
  has_many :partner_campaign_associations
  has_many :partners, :through => :partner_campaign_associations

  default_scope :order => 'name'
  named_scope :everything #this is so I can do crazy delegation in User

  validates_uniqueness_of :name
  has_permalink :name, :permalink
end

