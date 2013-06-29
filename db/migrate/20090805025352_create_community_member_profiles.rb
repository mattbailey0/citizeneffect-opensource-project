class CreateCommunityMemberProfiles < ActiveRecord::Migration
  def self.up
    create_table :community_member_profiles do |t|
      t.integer :project_id
      t.string :name
      t.text :biography
      
      # Attached profile picture
      t.string  :profile_picture_file_name
      t.string  :profile_picture_content_type
      t.string  :profile_picture_file_size
      t.string  :profile_picture_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :community_member_profiles
  end
end
