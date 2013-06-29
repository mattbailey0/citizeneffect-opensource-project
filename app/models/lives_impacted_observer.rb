class LivesImpactedObserver < ActiveRecord::Observer
  observe :project
  
  def before_save(object)
    LivesImpactedObserver.update_lives_impacted_range(object)
  end
  
  
  def self.update_lives_impacted_range(object)
    object.lives_impacted_range = LivesImpactedRange.fit_to_range(object.primary_lives_impacted || 0)
  end


end
