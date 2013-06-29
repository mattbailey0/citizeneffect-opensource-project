class RolePermissionAssociation < ActiveRecord::Base
  belongs_to :permission
  belongs_to :role
  
  # this should be totally unnecessary, but I'm way overengineering this
  validates_presence_of :permission
  validates_presence_of :role
end
