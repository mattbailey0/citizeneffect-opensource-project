class AddFacebookColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column "users", :facebook_auth_token, :string, :limit => 100
    add_column "users", :facebook_session_key, :string, :limit => 100
    add_column "users", :facebook_uid, :string, :limit => 100
  end

  def self.down
    remove_column "users", :facebook_uid, :string
    remove_column "users", :facebook_session_key, :string
    remove_column "users", :facebook_auth_token, :string
  end
end
