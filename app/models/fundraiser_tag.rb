class FundraiserTag < ActiveRecord::Base
  has_many :fundraiser_tag_associations
  has_many :fundraiser_types, :through => :fundraiser_tag_associations
  named_scope :alphabetical, :order => "name"
  validates_presence_of :name
  
  def self.determine_fundraising_goal_ranges(tag_ids)
    associations = FundraiserTagAssociation.find(:all, :conditions => {:fundraiser_tag_id => tag_ids})
    types = associations.map(&:fundraiser_type_id).join(',')
    
    return [] if types.blank?
    
    FundraisingGoalRange.find(:all,
                              :joins => "INNER JOIN fundraiser_types ON (fundraiser_types.minimum_typical_amount_raised_in_cents <= fundraising_goal_ranges.max_value OR IsNull(fundraising_goal_ranges.max_value)) AND (fundraiser_types.maximum_typical_amount_raised_in_cents >= fundraising_goal_ranges.min_value OR IsNull(fundraising_goal_ranges.min_value))",
                              :select => "DISTINCT fundraising_goal_ranges.*",
                              :conditions => "fundraiser_types.id IN (#{types})"
                              )
    
  end
  
  def name=(value)
    write_attribute("name", value.downcase)
  end
end
