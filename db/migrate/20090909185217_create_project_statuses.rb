require File.expand_path(File.dirname(__FILE__) + "/../bootstrap.rb")

class CreateProjectStatuses < ActiveRecord::Migration
  def self.up
    create_table :project_statuses do |t|
      t.string :display_name
      t.string :method_name
      t.timestamps
    end

    Bootstrapper.run :project_statuses
    
    tables_with_old_status_column = {
      "projects"                  => "state", 
      "community_member_audios"   => "related_project_stage",
      "community_member_pictures" => "related_project_stage",
      "community_member_videos"   => "related_project_stage",
    }

    tables_with_old_status_column.each_pair do |table_name, state_column_name|
      klass = table_name.classify.constantize
      
      add_column table_name, :project_status_id, :integer
      
      klass.reset_column_information
      
      klass.all.each do |p|
        p.project_status = ProjectStatus.find_by_display_name(p.read_attribute(state_column_name).titleize)
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
      
      remove_column table_name, state_column_name
    end
    
  end

  def self.down
    drop_table :project_statuses
  end
end
