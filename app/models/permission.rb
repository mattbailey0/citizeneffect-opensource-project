class Permission < ActiveRecord::Base
  has_many :role_permission_associations
  has_many :roles, :through => :role_permission_associations
  
  validates_presence_of :name
end
