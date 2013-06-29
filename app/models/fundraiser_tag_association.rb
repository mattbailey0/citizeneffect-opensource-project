class FundraiserTagAssociation < ActiveRecord::Base
  belongs_to :fundraiser_tag
  belongs_to :fundraiser_type
  
  validates_presence_of :fundraiser_tag
  validates_presence_of :fundraiser_type
end
