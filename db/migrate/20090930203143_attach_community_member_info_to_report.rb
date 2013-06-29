class AttachCommunityMemberInfoToReport < ActiveRecord::Migration
  def self.up
    drop_table :community_member_videos
    create_table :community_member_videos do |t|
      t.integer  :community_member_profile_id
      t.string   :caption
      t.string   :url
      t.integer  :project_report_id
      t.string   :project_report_type
      t.timestamps
    end
    
    drop_table :community_member_pictures
    create_table :community_member_pictures do |t|
      t.integer  :community_member_profile_id
      t.string   :caption
      t.integer  :project_report_id
      t.string   :project_report_type
      t.timestamps
    end
    
    drop_table :community_member_audios
    create_table :community_member_audios do |t|
      t.integer  :community_member_profile_id
      t.string   :caption
      t.integer  :project_report_id
      t.string   :project_report_type
      t.timestamps
    end
    
    drop_table :community_member_messages
    create_table :community_member_messages do |t|
      t.integer  :community_member_profile_id
      t.string   :content
      t.integer  :project_report_id
      t.string   :project_report_type
      t.timestamps
    end
    
    drop_table :community_member_profiles
    create_table :community_member_profiles do |t|
      t.integer  :project_id
      t.string   :name
      t.string   :title
      t.text     :biography
      t.timestamps
    end
  end

  def self.down
  end
end
