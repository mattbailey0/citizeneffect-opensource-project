class LivesImpactedRange < ActiveRecord::Base
  has_many :projects
  
  def self.fit_to_range(value)
    self.find(:first, :conditions => "(IsNull(min_value) OR #{value} >= min_value) AND (IsNull(max_value) OR #{value} <= max_value)")
  end
end
