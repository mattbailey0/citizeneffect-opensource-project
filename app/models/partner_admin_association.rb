class PartnerAdminAssociation < ActiveRecord::Base
  belongs_to :user
  belongs_to :partner
  
  before_save :set_partner_role
  before_destroy :remove_partner_role
  
  # this should be totally unnecessary, but I'm way overengineering this
  validates_presence_of :user
  validates_presence_of :partner
  
  def set_partner_role
    self.user.roles.add!(Role.partner_admin)
  end
  
  def remove_partner_role
    self.user.roles.remove!(Role.partner_admin) if self.user.partners.count == 1
  end

end
