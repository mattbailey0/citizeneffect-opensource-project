class CreateImportedContacts < ActiveRecord::Migration
  def self.up
    create_table :imported_contacts do |t|
      t.integer :referrer_id
      t.integer :user_id
      t.string  :name
      t.string  :email
      t.string  :referral_code
      t.boolean :recruited, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :imported_contacts
  end
end
