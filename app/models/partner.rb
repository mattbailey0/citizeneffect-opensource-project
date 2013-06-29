class Partner < ActiveRecord::Base
  include PermalinkHelper
  include GeocodeHelper

  acts_as_mappable
  before_save :update_geocode

  named_scope :everything #this is so I can do crazy delegation in User

  has_many :partner_admin_associations
  has_many :admins, :through => :partner_admin_associations, :source => :user
  has_many :partner_country_associations
  has_many :countries, :through => :partner_country_associations
  has_many :partner_focus_area_associations
  has_many :focus_areas, :through => :partner_focus_area_associations
  has_many :projects
  has_many :partner_campaign_associations
  has_many :campaigns, :through => :partner_camaign_associations
  
  has_one_unified_attachment :logo
  has_one_unified_attachment :representative_picture

  has_permalink    :display_name, :permalink

  def logo_url
    logo.andand.url(:partner_logo)
  end

  def geo_location
    Geokit::Geocoders::MultiGeocoder.geocode(self.long_location).ll  #returns latitude,longitude
  end

  def update_geocode
    if location_changed?
      self.geocode_address(self.long_location)
    end
  end

  def long_location
    "#{self.address1} #{self.address2} #{self.city} #{self.state} #{self.zip} #{self.country}"
  end

  def location_changed?
    (self.address1_changed? || self.address2_changed? || self.city_changed? ||
     self.state_changed? || self.zip_changed? || self.country_changed?) && !long_location.blank?
  end


end

