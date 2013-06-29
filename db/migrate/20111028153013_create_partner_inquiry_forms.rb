class CreatePartnerInquiryForms < ActiveRecord::Migration
  def self.up
    create_table "partner_inquiry_forms", :force => true do |t|
      t.string :source
      t.string :submitter_name
      t.string :submitter_email
      t.string :organization
      t.string :organization_phone_number
      t.string :organization_website
      t.string :contact_name
      t.string :contact_email
      t.string :description
      t.timestamps
    end
    add_index :partner_inquiry_forms, :source
    add_index :partner_inquiry_forms, :submitter_name
    add_index :partner_inquiry_forms, :submitter_email
    add_index :partner_inquiry_forms, :organization
    add_index :partner_inquiry_forms, :created_at
  end

  def self.down
    drop_table :partner_inquiry_forms
  end
end

