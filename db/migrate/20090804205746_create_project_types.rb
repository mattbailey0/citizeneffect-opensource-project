class CreateProjectTypes < ActiveRecord::Migration
  def self.up
    create_table :project_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :project_types
  end
end
