class AddDonorColumnsToDonation < ActiveRecord::Migration
  def self.up
    
    add_column "donations", :first_name            , :string 
    add_column "donations", :last_name             , :string 
    add_column "donations", :address1              , :string 
    add_column "donations", :address2              , :string 
    add_column "donations", :city                  , :string 
    add_column "donations", :state                 , :string 
    add_column "donations", :zip                   , :string 
    add_column "donations", :email                 , :string 
    add_column "donations", :phone_number          , :string 
    add_column "donations", :tip_percentage        , :integer, :default => 0
    add_column "donations", :mailing_list          , :boolean, :default => false
    add_column "donations", :anonymous             , :boolean, :default => false
    add_column "donations", :order_id              , :string
    add_column "donations", :authorization_code    , :string
    add_column "donations", :actual_amount_in_cents, :integer
    add_column "donations", :offline,                :boolean, :default => false
    
    rename_column "donations", :amount, :amount_in_cents
    
    Donation.reset_column_information
    Donation.all.each do |d|
      donor = Country.find_by_sql("SELECT * from donors where donors.id = #{d.donor_id}") #just use a holder class
      donor = donor.first
      
      d.donor_id        = donor.user_id
      d.first_name      = donor.name
      d.last_name       = donor.name
      d.address1        = donor.address1
      d.address2        = donor.address2
      d.city            = donor.city
      d.state           = donor.state
      d.zip             = donor.zip
      d.email           = donor.email
      d.phone_number    = donor.phone_number
      d.amount_in_cents = d.amount_in_cents * 100
      unless d.save
        o = d
        puts <<-STR
          WARNING ========================================================
            Couldn\'t update existing #{o.class.name} ID: #{o.id}
            errors: #{o.errors.full_messages.to_sentence}
            Continuing anyway
          WARNING ========================================================
        STR
      end
    end
    
    drop_table "donors"
  end

  def self.down
  end
end
