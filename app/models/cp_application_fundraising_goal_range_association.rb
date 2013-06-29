class CpApplicationFundraisingGoalRangeAssociation < ActiveRecord::Base
  belongs_to :cp_application
  belongs_to :fundraising_goal_range
end
