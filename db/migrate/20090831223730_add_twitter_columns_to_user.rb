class AddTwitterColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column "users", :twitter_access_key, :string, :limit => 50
    add_column "users", :twitter_secret_key, :string, :limit => 50
  end

  def self.down
    remove_column "users", :twitter_secret_key, :string
    remove_column "users", :twitter_access_key, :string
  end
end
