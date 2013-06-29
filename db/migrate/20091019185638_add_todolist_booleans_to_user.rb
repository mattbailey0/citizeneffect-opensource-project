class AddTodolistBooleansToUser < ActiveRecord::Migration
  def self.up
    add_column "users", :display_facebook_todo, :boolean, :default => true
    add_column "users", :display_twitter_todo,  :boolean, :default => true
    add_column "users", :display_myspace_todo,  :boolean, :default => true
    add_column "users", :display_contact_todo,  :boolean, :default => true
    add_column "users", :display_invite_todo,   :boolean, :default => true
  end

  def self.down
  end
end
