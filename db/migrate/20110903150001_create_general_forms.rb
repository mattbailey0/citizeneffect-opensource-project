class CreateGeneralForms < ActiveRecord::Migration
  def self.up
    create_table "general_forms", :force => true do |t|
      t.string :source
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.string :location
      t.string :location_other
      t.string :cause
      t.string :referred_by
      t.string :campaign_code
      t.timestamps
    end
    add_index :general_forms, :last_name
    add_index :general_forms, :email
    add_index :general_forms, :created_at
  end

  def self.down
    drop_table "general_forms"
  end
end
