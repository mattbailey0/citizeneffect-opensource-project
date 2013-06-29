class AddTrackingFieldsToMailingListUser < ActiveRecord::Migration
  def self.up
    add_column "mailing_list_users", :first_name,    :string
    add_column "mailing_list_users", :last_name,     :string
    add_column "mailing_list_users", :tracking_code, :string
  end

  def self.down
    remove_column "mailing_list_users", :first_name
    remove_column "mailing_list_users", :last_name
    remove_column "mailing_list_users", :tracking_code
  end
end
