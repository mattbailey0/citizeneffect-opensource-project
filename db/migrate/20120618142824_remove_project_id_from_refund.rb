class RemoveProjectIdFromRefund < ActiveRecord::Migration
  def self.up
    remove_column :refunds, :project_id
  end

  def self.down
    add_column :refunds, :project_id, :integer
  end
end
