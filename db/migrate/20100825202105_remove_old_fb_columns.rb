class RemoveOldFbColumns < ActiveRecord::Migration
  def self.up
    remove_column :users, :facebook_session_key
    remove_column :users, :facebook_uid
    User.reset_column_information
    User.find_each do |u|
      u.update_attributes(:facebook_auth_token => nil)
    end
  end

  def self.down
  end
end
