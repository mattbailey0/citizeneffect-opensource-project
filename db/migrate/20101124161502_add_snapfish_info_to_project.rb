class AddSnapfishInfoToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :enable_card_donation, :boolean, :allow_nil => false, :default => false
    add_column :projects, :card_donation_cost_in_cents, :integer, :allow_nil => false, :default => 0
    add_column :projects, :card_image_url, :string
    add_column :projects, :card_snapfish_url, :text
    
    Project.reset_column_information
    
    { 
      370 => { 
        :enable_card_donation => true,
        :card_donation_cost_in_cents => 375,
        :card_image_url => "/images/giftcard-peru.jpg",
        :card_snapfish_url => ""
      },
      369 => { 
        :enable_card_donation => true,
        :card_donation_cost_in_cents => 375,
        :card_image_url => "/images/giftcard-india.jpg",
        :card_snapfish_url => ""
      },
      372 => { 
        :enable_card_donation => true,
        :card_donation_cost_in_cents => 375,
        :card_image_url => "/images/giftcard-africa.jpg",
        :card_snapfish_url => ""
      },
      371 => { 
        :enable_card_donation => true,
        :card_donation_cost_in_cents => 375,
        :card_image_url => "/images/giftcard-usa.jpg",
        :card_snapfish_url => ""
      },
    }.each do |k, v|
      Project.find(k).update_attributes(v)
    end
  end

  def self.down
  end
end
