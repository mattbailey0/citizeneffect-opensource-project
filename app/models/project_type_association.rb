class ProjectTypeAssociation < ActiveRecord::Base
  belongs_to :project_type
  belongs_to :project
  
  # this should be totally unnecessary, but I'm way overengineering this
  validates_presence_of :project
  validates_presence_of :project_type
end
