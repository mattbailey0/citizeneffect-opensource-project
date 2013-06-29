class WatchedProjectAssociation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  validates_presence_of :user
  validates_presence_of :project
  
  validates_uniqueness_of :user_id, :scope => [:project_id]
end
