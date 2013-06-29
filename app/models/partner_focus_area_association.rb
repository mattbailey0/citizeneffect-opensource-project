class PartnerFocusAreaAssociation < ActiveRecord::Base
  belongs_to :partner
  belongs_to :focus_area
  
  # this should be totally unnecessary, but I'm way overengineering this
  validates_presence_of :partner
  validates_presence_of :focus_area
end
