require File.expand_path(File.dirname(__FILE__) + "/../bootstrap.rb")

class CreateLivesImpactedRanges < ActiveRecord::Migration
  def self.up
    create_table :lives_impacted_ranges do |t|
      t.string  :display_name
      t.integer :min_value
      t.integer :max_value
      t.timestamps
    end
    
    Bootstrapper.run :lives_impacted_ranges
    
    add_column "projects", :lives_impacted_range_id, :integer
    
    Project.reset_column_information
    
    Project.all.each do |p|
      LivesImpactedObserver.update_lives_impacted_range(p)
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
    drop_table :lives_impacted_ranges
  end
end
