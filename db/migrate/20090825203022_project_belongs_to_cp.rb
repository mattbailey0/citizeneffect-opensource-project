class ProjectBelongsToCp < ActiveRecord::Migration
  def self.up
    $SKIP_VALIDATIONS = true
    add_column "projects", :cp_id, :integer
  end

  def self.down
    remove_column "projects", :cp_id, :integer
  end
end
