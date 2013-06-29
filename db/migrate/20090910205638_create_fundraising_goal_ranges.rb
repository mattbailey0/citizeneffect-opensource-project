require File.expand_path(File.dirname(__FILE__) + "/../bootstrap.rb")

class CreateFundraisingGoalRanges < ActiveRecord::Migration
  def self.up
    create_table :fundraising_goal_ranges do |t|
      t.string  :display_name
      t.integer :min_value
      t.integer :max_value
      t.timestamps
    end
    
    Bootstrapper.run :fundraising_goal_ranges
    
    add_column "projects", :fundraising_goal_range_id, :integer
    
    Project.reset_column_information
    
    Project.all.each do |p|
      FundraisingGoalObserver.update_fundraising_goal_range(p)
      unless p.save
        o = p
        puts <<-STR
          WARNING ========================================================
            Couldn\'t update existing #{o.class.name} ID: #{o.id}
            errors: #{o.errors.full_messages.to_sentence}
            Continuing anyway
          WARNING ========================================================
        STR
      end
    end
  end

  def self.down
    drop_table :fundraising_goal_ranges
  end
end
