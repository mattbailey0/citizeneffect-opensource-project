require File.dirname(__FILE__) + "/../test_helper"

class DonationTest < ActiveSupport::TestCase
  test "donations can't have negative amount" do
    donation = Factory.build(:donation, :amount_in_cents => -2)
    assert !donation.valid?
    assert_match(/Amount in cents must be positive/, donation.errors.full_messages.join(", "))
  end
  
  test "donations can't have zero amount" do
    donation = Factory.build(:donation, :amount_in_cents => 0)
    assert !donation.valid?
    assert_match(/Amount in cents must be positive/, donation.errors.full_messages.join(", "))
  end
end
