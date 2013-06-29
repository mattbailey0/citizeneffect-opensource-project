class ProjectType < ActiveRecord::Base
  validates_presence_of       :name
  has_one_unified_attachment  :icon 
end
