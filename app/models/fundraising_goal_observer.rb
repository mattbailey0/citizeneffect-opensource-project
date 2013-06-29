class FundraisingGoalObserver < ActiveRecord::Observer
  observe :project
  
  def before_save(object)
    FundraisingGoalObserver.update_fundraising_goal_range(object)
  end
  
  
  def self.update_fundraising_goal_range(object)
    object.fundraising_goal_range = FundraisingGoalRange.fit_to_range(object.total_cost_in_us_cents.to_i)
  end


end
