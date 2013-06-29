class Donation < ActiveRecord::Base
  SNAPFISH_PROMO_CODE = ""
  SNAPFISH_CARD  = ""
  YOGA = ""
  BRACKETS = ""

  include CommonNamedScopes

  @@gateway = ActiveMerchant::Billing::CyberSourceGateway.new({
                                                                :login	  => CYBERSOURCE_USERID,
                                                                :password => CYBERSOURCE_TRANSACTION_KEY,
                                                              })

  # We need a heinous hash here because apparently ActiveMerchant doesn't provide any kind of
  # good looking text for the credit card types.
  # PUBLIC_CREDIT_CARD_TYPES_HASH = ActiveMerchant::Billing::CyberSourceGateway.supported_cardtypes.inject({}) {|m,o| m[o.to_s.titleize] = o.to_s; m }
  # CE Can only accept visa or mastercard
  PUBLIC_CREDIT_CARD_TYPES_HASH = [:visa, :master].inject({}) {|m,o| m[o.to_s.titleize] = o.to_s; m }

  AMOUNT_OPTIONS = [10,25,50,100,500,1000]
  AMOUNT_OPTIONS_SEVENS = [7.2, 72, 720, 7200]
  OTHER          = "Other"
  TIP_OPTIONS    = [0,5,10,20]
  TIP_DEFAULT    = 10

  belongs_to :donor, :class_name => "User"
  belongs_to :project
  belongs_to :donation_cp, :foreign_key => "donation_attribution_id", :class_name => "User"
  has_many :refunds,
    :after_add => :update_net_totals,
    :after_remove => :update_net_totals
  
  named_scope :recent, :order => "donated_at DESC"
  named_scope :redacted, :select => "id,amount_in_cents"

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :country
  validates_presence_of :email
  validates_presence_of :tip_percentage
  validates_presence_of :amount_in_cents

  validates_numericality_of :amount_in_cents, :greater_than => 0, :message => "must be positive"
  validates_numericality_of :tip_percentage, :greater_than_or_equal_to => 0, :message => "must be positive"
  validate_on_create :must_agree_to_tos
  validate_on_create :yogachallenge_validations
  
  after_create :yogachallenge_after_create
  after_create :send_email_if_offline
  before_save :associate_with_user
  before_save :associate_with_cp
  before_validation :set_amount_correctly
  before_update :set_project_amount

  before_save :update_net_totals

  attr_accessor :credit_card_number,
                :expiration_month,
                :expiration_year,
                :credit_card_cvv,
                :public_credit_card_type,
                :credit_card_type,
                :credit_card,
                :other_amount_in_dollars,
                :select_box_amount_in_dollars,
                :agree_tos,
                :extra_ten,                 #brackets with benefits one-off "double your impact!"  cruft cruft cruft
                :fundraise_commitment,
                :password_confirmation,
                :password,
                :referred_by

  def after_initialize
    self.amount_in_dollars = 10.0 unless self.amount_in_dollars > 0
    self.donated_at ||= Time.now
  end
  
  def update_net_totals
    self.refunds_total_in_cents = self.calculate_refunds_total
    self.net_actual_amount_in_cents = self.calculate_net_actual_amount_in_cents
    self.net_amount_in_cents = self.calculate_net_amount_in_cents
  end
  
  def calculate_refunds_total
    self.refunds.sum(:amount_in_cents)
  end
  
  def calculate_net_amount_in_cents
    ((self.actual_amount_in_cents - self.refunded_amount_in_cents).to_f / 
    ((100 + self.current_tip_percentage).to_f ) *  
    100
    ).floor
  end

  def calculate_net_actual_amount_in_cents
    self.actual_amount_in_cents - self.refunded_amount_in_cents
  end
  
  def must_agree_to_tos
    unless self.offline
      self.errors.add_to_base("You must agreee to the Terms of Service") unless self.agree_tos == "1"
    end
  end

  def yogachallenge_validations
    return unless self.campaign_code == Donation::YOGA
    self.errors.add_to_base("You must agreee to Fundraise") unless self.fundraise_commitment == "1"
    self.errors.add(:phone_number, "can't be blank") if self.phone_number.blank?
    unless self.donor
      @eventual_donor = User.new(:password => self.password,
                            :password_confirmation => self.password_confirmation,
                            :email => self.email,
                            :first_name => self.first_name,
                            :last_name => self.last_name,
                            :zip => self.zip,
                            :address1 => self.address1,
                            :address2 => self.address2,
                            :phone_number => self.phone_number,
                            :city_name => self.city,
                            :state_name => self.state,
                            :state_code => self.state)
      @eventual_donor.valid?
      @eventual_donor.errors.each do |i,j|
        next if (i == "email" || i == "zip") && j == "can't be blank" #done by local validations
        self.errors.add(i, j)
      end
    end
  end

  def yogachallenge_after_create
    return true unless self.campaign_code == Donation::YOGA
    if @eventual_donor
      @eventual_donor.register!
      self.donor = @eventual_donor
      save
    else
      self.donor.update_attributes(:zip => self.zip,
                                   :address1 => self.address1,
                                   :address2 => self.address2,
                                   :phone_number => self.phone_number,
                                   :city_name => self.city,
                                   :state_name => self.state,
                                   :state_code => self.state)
    end
    CpApplication.create!(:user => self.donor,
                          :dont_send_application_email => true,
                          :terms_of_service => "1",
                          :fundraising_goal_range => FundraisingGoalRange.first, # < 5K
                          :countries => [Country.find_by_id(12)].compact, # USA
                          :comment => "Yoga Challenge 2011: #{self.referred_by}")
  end

  def signup_for_mailing_list
    return true if (!self.mailing_list || self.offline)
    if self.donor
      MailingListUser.create(:user => self.donor, :mailing_list => MailingList.global_list)
      MailingListUser.create(:user => self.donor, :mailing_list => self.project.mailing_list) if self.project
    else
      MailingListUser.create(:email => self.email, :zip => self.zip, :mailing_list => MailingList.global_list)
      if self.project
        MailingListUser.create(:email => self.email, :zip => self.zip, :mailing_list => self.project.mailing_list)
      end
    end
    true
  end

  def set_amount_correctly
    if self.ar_select_box_amount_in_dollars.to_f != 0
      self.amount_in_dollars = self.ar_select_box_amount_in_dollars.to_f
    elsif !self.ar_other_amount_in_dollars.blank? && self.ar_select_box_amount_in_dollars == OTHER
      self.amount_in_dollars = self.ar_other_amount_in_dollars
    end

    self.other_amount_in_dollars = nil
    self.select_box_amount_in_dollars = nil
  end
  
  def send_email_if_offline
    self.send_cp_donation_made_email if self.offline
  end

  def associate_with_user
    if(self.offline)
      self.donor = User.find_by_email(self.email)
      self.set_actual_amount(false)
      self.set_fee_amount
      self.set_project_amount
    end
  end

  def associate_with_cp
    self.donation_cp ||= self.project.andand.cp
  end

  def save_and_charge_with_rollback
    self.class.transaction do
      raise ActiveRecord::Rollback unless self.charge
      true
    end
  end

  def public_credit_card_type=(value)
    self.credit_card_type = PUBLIC_CREDIT_CARD_TYPES_HASH[value]
    @public_credit_card_type = value
  end

  ############   _amount_ functions:    ############
  # *_amount_in_        =>  The base donation amount - the amount the donor typed into the form, before fees and tip.
  # *_actual_amount_in  =>  The amount_in including fee and tip.  Equates to the amount that showed up on the donor's card.
  # *_project_amount_in =>  The amount that is applied to the project.  the base donation amount *less* fee.
  # net_*               =>  The returned amount less refunds.  This is usually the one you want.
  ############                          ############

  #Amount: the base donation amount. 
  # => does not include tip or take fees into account.
  def amount_in_dollars
    MoneyConversion.cents_to_dollars(self.amount_in_cents)
  end

  def amount_in_dollars=(value)
    self.amount_in_cents = MoneyConversion.dollars_to_cents(value)
  end

  def net_amount_in_dollars
      MoneyConversion.cents_to_dollars(self.net_amount_in_cents)
  end
  
  def net_amount_in_cents
      self[:net_amount_in_cents] ? self[:net_amount_in_cents] : self.amount_in_cents
  end
  
  
  #Actual Amount: the amount charged to the credit card or written on the check
  # => amount + tip (includes fees)
  def actual_amount_in_dollars
    MoneyConversion.cents_to_dollars(self.actual_amount_in_cents)
  end

  def net_actual_amount_in_dollars
      MoneyConversion.cents_to_dollars(self.net_actual_amount_in_cents)
  end
  
  def net_actual_amount_in_cents
      self[:net_actual_amount_in_cents] ? self[:net_actual_amount_in_cents] : self.actual_amount_in_cents
  end
  

  #Project Amount: the amount out of the total to be disbursed to the project 
  # => amount - fees
  # => note that the total fee amount is taken from the project, not from the tip.
  def project_amount_in_dollars
    MoneyConversion.cents_to_dollars(self.project_amount_in_cents.to_i)
  end
  
  def net_project_amount_in_dollars
    MoneyConversion.cents_to_dollars(self.net_project_amount_in_cents)
  end
  
  def net_project_amount_in_cents
      self[:net_project_amount_in_cents] ? self[:net_project_amount_in_cents] : self.project_amount_in_cents
  end
  
  
  def refunded_amount_in_cents
    self.refunds_total_in_cents ? self.refunds_total_in_cents : 0
  end  
  
  def refunded_amount_in_dollars
    MoneyConversion.cents_to_dollars(self.refunded_amount_in_cents)
  end
  
  
  #the operational funds provided by the donation
  # => for project donations: tip - total original cc fee amount + however much of that was covered by the project
  # => for non-project donations: net amount + tip - total original cc fee amount
  def net_ce_amount_in_dollars
    if self.project
      if self.net_project_amount_in_cents > 0
        MoneyConversion.cents_to_dollars( self.current_tip_amount_in_cents - self.fee_amount_in_cents + self.current_project_fee_amount_in_cents)
      else
        MoneyConversion.cents_to_dollars(self.net_amount_in_cents - self.fee_amount_in_cents)
      end
    else
      MoneyConversion.cents_to_dollars(self.net_amount_in_cents - self.fee_amount_in_cents + (self.net_amount_in_cents * self.current_tip_percentage / 100).floor)
    end
  end
  
  
  #sets the (credit card) fee based on the date.  
   #when changing the rate, add it to the if/else here and preserve for historical purposes. (ok to comment out, natch) 
   def set_fee_percentage
     if !self.offline || self.offline == 0
       if Date.today > Date.new(2012,8,1) 
         self.fee_percentage = 0.035
       else
         self.fee_percentage = 0.03  
       end
     else
       self.fee_percentage = 0.0
     end
   end

   #Set the fee amount for the transaction
   #Notes: 
   # => this is an estimation, since it's not in communication with the payment processor
   # => the fee is set based on the actual_amount - meaning amount + tip
   # => however, the project_amount is the amount minus the entire fee - the tip stands alone.
   def set_fee_amount
     self.fee_amount_in_cents = (self.actual_amount_in_cents * self.fee_percentage.to_f).floor 
   end
    
   def fee_amount_in_dollars
     MoneyConversion.cents_to_dollars(self.fee_amount_in_cents)
   end
  
   def current_project_fee_amount_in_cents
     if self.fee_amount_in_cents <= self.current_tip_amount_in_cents
       (self.net_amount_in_cents * self.fee_percentage.to_f).floor
     elsif self.fee_amount_in_cents - self.current_tip_amount_in_cents <= self.net_amount_in_cents 
        self.fee_amount_in_cents - self.current_tip_amount_in_cents
     else
        self.net_amount_in_cents
     end
   end

   def current_tip_percentage
     self.revised_tip_percentage ? self.revised_tip_percentage : self.tip_percentage
   end
  
  def current_tip_amount_in_cents
    (self.net_amount_in_cents * self.current_tip_percentage / 100).floor
  end
  
  alias :ar_other_amount_in_dollars :other_amount_in_dollars
  def other_amount_in_dollars
    self.ar_other_amount_in_dollars || 0 # self.amount_in_dollars (CE asked that this default to 0, not 10)
  end

  alias :ar_select_box_amount_in_dollars :select_box_amount_in_dollars
  def select_box_amount_in_dollars
    box = self.ar_select_box_amount_in_dollars
    return box if box
    return self.amount_in_dollars if AMOUNT_OPTIONS.include?(self.amount_in_dollars)
    OTHER
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def display_location
    if self.anonymous
      ""
    else
      comma = (self.city.blank? || self.state.blank?) ? "" : ", "
      "#{self.city}#{comma}#{self.state}"
    end
  end

  def display_name
    if self.anonymous
      "Anonymous"
    elsif self.last_name == "Admin"
      "#{self.first_name} #{self.last_name}"
    elsif self.last_name.blank?
       self.first_name
    else
      "#{self.first_name} #{self.last_name.andand.slice(0,1)}."
    end
  end

  def picture_url_thumb(size_name = :standard_thumb)
    pic = self.donor.andand.picture.andand.url(size_name)
    if self.anonymous || pic.nil?
      UnifiedUpload.new(:flavor => "user").url(size_name)
    else
      pic
    end
  end

  alias :ar_donor= :donor=
  def donor=(donor)
    self.ar_donor = donor
    return unless donor

    self.first_name   ||= donor.first_name
    self.last_name    ||= donor.last_name
    self.address1     ||= donor.address1
    self.address2     ||= donor.address2
    self.city         ||= donor.city_name
    self.state        ||= donor.state_name
    self.zip          ||= donor.zip
    self.email        ||= donor.email
    self.phone_number ||= donor.phone_number
  end

  alias :ar_valid? :valid?
  def valid?
    result = self.ar_valid?

    if self.credit_card.blank? || self.credit_card.valid?
      result
    else
      add_credit_card_errors
      false
    end
  end

  protected

  def charge
    return false unless self.authorization_code.blank?

    self.create_card

    if(!self.valid?)
      false
    else
      self.prepare_and_charge_card
    end
  end

  def create_card
    self.credit_card = ActiveMerchant::Billing::CreditCard.new({
                                                                 :first_name         => self.first_name,
                                                                 :last_name          => self.last_name,
                                                                 :number             => self.credit_card_number,
                                                                 :month              => self.expiration_month,
                                                                 :year               => self.expiration_year,
                                                                 :verification_value => self.credit_card_cvv,
                                                                 :type               => self.credit_card_type
                                                               })
  end

  def prepare_and_charge_card
    self.generate_order_id
    self.set_actual_amount
    self.set_fee_amount
    self.set_project_amount
    
    if self.save
      self.charge_and_check_result
    else
      false
    end
  end

  def charge_and_check_result
    response = @@gateway.purchase(self.actual_amount_in_cents, self.credit_card,
                                { :order_id        => self.order_id,
                                  :email           => self.email,
                                  :billing_address => {
                                    :address1      => self.address1,
                                    :address2      => self.address2,
                                    :city          => self.city,
                                    :country       => self.country,
                                    :state         => self.state,
                                    :zip           => self.zip
                                  }})

    if response.success?
      self.authorization_code = response.authorization
      self.save!
      self.send_email
      response
    else
      logger.info "Credit card transaction failed due to: #{response.message}"
      self.errors.add_to_base(
            "Failed to charge the given credit card.  Are you sure all of your information is correct?")
      false
    end
  end

  def add_credit_card_errors
    self.credit_card.errors.each do |key, value|
      message = case key
                when "number"             then "Invalid credit card number"
                when "month"              then "Invalid credit card expiration month"
                when "type"               then "Invalid credit card type"
                when "year"               then "Invalid credit card expiration year"
                when "verification_value" then "Invalid credit card security code"
                when "first_name"         then false #ignore, taken care of by rails
                when "last_name"          then false #ignore, taken care of by rails
                else nil
                end
      if message
        self.errors.add_to_base(message)
      elsif message.nil?
        self.errors.add(key, value)
      end
    end
  end

  def set_actual_amount(credit_card_fee = true)
    self.actual_amount_in_cents = (self.amount_in_cents * (1 + self.tip_percentage / 100.0)).floor
    self.actual_amount_in_cents += 1000 unless self.extra_ten.to_i == 0       #brackets with benefits cruft

    if self.project
      if self.project.enable_card_donation && self.campaign_code == Donation::SNAPFISH_CARD
        self.actual_amount_in_cents += self.project.card_donation_cost_in_cents
      end
    end
  end


  
  #Note:
  # => The project_amount is the amount minus the fee for the entire transaction, including tip.
  # => So, if you have a $100 amount with a 10% tip = $110 and a 10% fee, the project amount is 100-11=$89, not 100-10=$90 like you might expect.
  # => IN SHORT: the entire fee for the transaction is applied to the project and the tip is passed straight through.
  def set_project_amount
    if self.project
      self.net_project_amount_in_cents = self.net_amount_in_cents - self.current_project_fee_amount_in_cents
      if self.net_project_amount_in_cents < 0
        self.net_project_amount_in_cents = 0  #not allowed to have negative amount
          #above line is a problem - should be debiting this amount off of a stored ce value..
      end
    else
      self.net_project_amount_in_cents = 0
    end
    self.project_amount_in_cents = self.net_project_amount_in_cents if self.new_record? 
  end


  #this should only be done if refunding the whole balance
  def remove_tip
    unless self.current_tip_percentage == 0
      #r = Refund.new(
      #      :amount_in_cents => self.current_tip_amount_in_cents, 
      #      :comment => "Automatic refund of tip value."
      #)
      #self.amount_in_cents += self.current_tip_amount_in_cents
      self.revised_tip_percentage = 0
      self.net_actual_amount_in_cents = self.calculate_net_actual_amount_in_cents
      #r.donation = self
      #r.save
    end
  end

  def generate_order_id
    self.order_id = self.id.to_s + Time.now.to_i.to_s
  end

  def send_email
    email = DonationReceiptEmail.create(
                                        :donation       => self,
                                        :recipients     => [self.email]
                                        )
    email.send_later(:send!)
    self.send_cp_donation_made_email
  end

  def send_cp_donation_made_email
    if self.project && self.project.cp && self.project.cp.email
      return if CpDonationMadeEmail.count(:all, :conditions => { :donation_id => self.id }) > 0
      email = CpDonationMadeEmail.create(
                                         :donation   => self,
                                         :recipients => [self.project.cp.email]
                                         )
      email.send_later(:send!)
    end
  end

end

