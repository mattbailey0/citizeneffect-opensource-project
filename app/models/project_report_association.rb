class ProjectReportAssociation < ActiveRecord::Base
  belongs_to :project
  belongs_to :project_report, :polymorphic => true
  
  #validates_uniquenes_of :project_id, :scope => [:project_report_id, :project_report_type]
end
