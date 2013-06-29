class CreateCpApplications < ActiveRecord::Migration
  def self.up
    create_table :cp_applications do |t|
      t.integer :user_id
      t.integer :project_id
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :cp_applications
  end
end
