class CreateProjectReportAssociations < ActiveRecord::Migration
  def self.up
    create_table :project_report_associations do |t|
      t.integer  :project_id
      t.integer  :project_report_id
      t.string   :project_report_type
      t.timestamps
    end
  end

  def self.down
    drop_table :project_report_associations
  end
end
