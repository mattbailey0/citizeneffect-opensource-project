class CreateNgoUserDetails < ActiveRecord::Migration
  def self.up
    create_table :ngo_user_details do |t|
      t.boolean :necessary
      
      

      t.timestamps
    end
  end

  def self.down
    drop_table :ngo_user_details
  end
end
