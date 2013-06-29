class CreateBasicUserDetails < ActiveRecord::Migration
  def self.up
    create_table :basic_user_details do |t|
      t.string :first_name
      t.string :last_name
      t.string :zip
      t.string :phone_number
      t.string :skype_username
      t.timestamps
    end
  end

  def self.down
    drop_table :basic_user_details
  end
end
