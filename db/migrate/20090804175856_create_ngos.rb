class CreateNgos < ActiveRecord::Migration
  def self.up
    create_table :ngos do |t|
      t.string :display_name
      t.string :full_name
      t.string :permalink
      t.string :url
      t.string :public_email
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone_number
      t.string :fax_number
      t.text   :details_for_website
      
      # Fields for attachments
      t.string  :logo_file_name
      t.string  :logo_content_type
      t.string  :logo_file_size
      t.string  :logo_updated_at
      t.string  :representative_picture_file_name
      t.string  :representative_picture_content_type
      t.string  :representative_picture_file_size
      t.string  :representative_picture_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :ngos
  end
end
