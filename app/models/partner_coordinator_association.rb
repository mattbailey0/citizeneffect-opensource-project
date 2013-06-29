class PartnerCoordinatorAssociation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  # this should be totally unnecessary, but I'm way overengineering this
  validates_presence_of :user
  validates_presence_of :project
end
