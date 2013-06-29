class Role < ActiveRecord::Base
  has_many :role_permission_associations
  has_many :permissions, :through => :role_permission_associations

  has_many :user_role_associations
  has_many :users, :through => :user_role_associations, :uniq => true
  
  named_scope :highest, :order => "id ASC", :limit => 1 # STUB, to display anywhere we show a user's role (like in header).  I'd like this to return a role, not an array with one role, so I just dropped a .first where I used it for now

  validates_presence_of :name
  
  def self.partner_admin
    self.find_by_name("partner_admin")
  end
  
  def self.cp
    self.find_by_name("cp")
  end
  
  def self.citizen_effect_admin
    self.find_by_name("citizen_effect_admin")
  end
  
  def self.basic_user
    self.find_by_name("basic_user")
  end
end
