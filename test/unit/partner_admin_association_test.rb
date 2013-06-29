require File.dirname(__FILE__) + "/../test_helper"
#require 'test_helper'

class PartnerAdminAssociationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "saving updates the partner role on the associated user" do
    u = Factory.create(:user)
    paa = Factory.create(:partner_admin_association)
    partner_admin_role = Role.find_by_name("partner_admin")
    assert !u.roles.include?(partner_admin_role)
    
    paa.user = u
    paa.save
    assert u.roles(true).include?(partner_admin_role)
  end
end
