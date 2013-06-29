require File.expand_path(File.dirname(__FILE__) + "/../bootstrap.rb")

class CreateMailingLists < ActiveRecord::Migration
  def self.up
    create_table :mailing_lists do |t|
      t.integer :project_id
      t.timestamps
    end

    Bootstrapper.run :global_mailing_list
    
    # add a mailing list to all existing projects
    Project.all.each do |p|
      unless p.mailing_list
        p.mailing_list = MailingList.new 
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
  end

  def self.down
    drop_table :mailing_lists
  end
end
