class PartnerCountryAssociation < ActiveRecord::Base
  belongs_to :partner
  belongs_to :country
  
  # this should be totally unnecessary, but I'm way overengineering this
  validates_presence_of :partner
  validates_presence_of :country
end
