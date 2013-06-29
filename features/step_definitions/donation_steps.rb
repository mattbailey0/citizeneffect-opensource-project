Given /^that donation is for the amount of "([^\"]*)" dollars$/ do |amount_in_dollars|
  amount_in_cents = (amount_in_dollars.to_f * 100).to_i
  @recent_donation.update_attributes!(:amount_in_cents => amount_in_cents)
end

When /^I fill in the credit card information$/ do 
  When %Q{I select "Visa" from "Credit Card Type"}
  When %Q{I fill in "Credit Card Number" with "4242424242424242"}
  When %Q{I fill in "donation_expiration_month" with "8" }
  When %Q{I fill in "donation_expiration_year" with "2012" }
  When %Q{I fill in "Security Code" with "123"}
end
