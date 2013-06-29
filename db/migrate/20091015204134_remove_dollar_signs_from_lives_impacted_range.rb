class RemoveDollarSignsFromLivesImpactedRange < ActiveRecord::Migration
  def self.up
    low    = LivesImpactedRange.find(1)
    medium = LivesImpactedRange.find(2)
    high   = LivesImpactedRange.find(3)
    
    low   .update_attribute(:display_name, "0 - 500")
    medium.update_attribute(:display_name, "500 - 100")
    high  .update_attribute(:display_name, "> 1000")
  end

  def self.down
  end
end
