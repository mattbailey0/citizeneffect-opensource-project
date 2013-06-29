class CreateCommunityMemberAudios < ActiveRecord::Migration
  def self.up
    create_table :community_member_audios do |t|
      t.integer :community_member_profile_id
      t.string  :caption
      t.string  :related_project_stage
      t.string  :audio_file_name
      t.string  :audio_content_type
      t.string  :audio_file_size
      t.string  :audio_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :community_member_audios
  end
end
