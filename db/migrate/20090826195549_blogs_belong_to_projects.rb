require File.expand_path(File.dirname(__FILE__) + "/../bootstrap.rb")

class BlogsBelongToProjects < ActiveRecord::Migration
  def self.up
    add_column "blogs", :project_id, :integer

    Project.delete_observers # to avoid cyclic dependency

    Bootstrapper.run :blog_categories
    Bootstrapper.run :main_blog
    Project.all.each do |p|
      p.new_blog_for_project
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
      p.update_blog_url
    end
  end

  def self.down
    remove_column "blogs", :project_id, :integer
  end
end
