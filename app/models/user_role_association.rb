class UserRoleAssociation < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  
  # this should be totally unnecessary, but I'm way overengineering this
#   validates_presence_of :user
#   validates_presence_of :role
end
