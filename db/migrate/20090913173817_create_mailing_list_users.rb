class CreateMailingListUsers < ActiveRecord::Migration
  def self.up
    create_table :mailing_list_users do |t|
      t.integer :user_id
      t.integer :mailing_list_id
      t.string  :zip
      t.string  :email
      t.string  :unsubscribe_token
      t.timestamps
    end
  end

  def self.down
    drop_table :mailing_list_users
  end
end
