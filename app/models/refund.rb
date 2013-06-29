class Refund < ActiveRecord::Base
  belongs_to :donation

  validate_on_create :amount_is_appropriate
  after_create :update_donation
  after_destroy :update_donation
  
    
  def amount_is_appropriate
    unless self.donation.net_actual_amount_in_cents >= self.amount_in_cents
      self.errors.add_to_base("You cannot refund more than the remaining Net Amount Charged.")
    end
  end
  
  def update_donation
    self.refund_donation_tip_if_needed
    self.donation.update_net_totals
    self.donation.save
  end
  
  def refund_donation_tip_if_needed
    if (self.donation.net_project_amount_in_cents - self.amount_in_cents < 0) ||
          (self.donation.net_project_amount_in_cents - self.amount_in_cents == 0 && self.donation.project) ||
          (self.donation.net_amount_in_cents - self.amount_in_cents == 0 && !self.donation.project)
      self.donation.remove_tip
    end
  end
  
  def amount_in_dollars
    MoneyConversion.cents_to_dollars(self.amount_in_cents)
  end

  def amount_in_dollars=(value)
    self.amount_in_cents = MoneyConversion.dollars_to_cents(value)
  end

end
