class AddMyspaceColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column "users", :myspace_access_key, :string
    add_column "users", :myspace_secret_key, :string
  end

  def self.down
    remove_column "users", :myspace_secret_key, :string
    remove_column "users", :myspace_access_key, :string
  end
end
