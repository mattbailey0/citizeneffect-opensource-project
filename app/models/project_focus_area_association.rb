class ProjectFocusAreaAssociation < ActiveRecord::Base
  belongs_to :project
  belongs_to :focus_area
  
  # this should be totally unnecessary, but I'm way overengineering this
  validates_presence_of :project
  validates_presence_of :focus_area
end
