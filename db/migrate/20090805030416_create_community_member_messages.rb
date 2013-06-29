class CreateCommunityMemberMessages < ActiveRecord::Migration
  def self.up
    create_table :community_member_messages do |t|
      t.integer :community_member_profile_id
      t.text    :content
      t.string  :related_project_stage
      t.timestamps
    end
  end

  def self.down
    drop_table :community_member_messages
  end
end
