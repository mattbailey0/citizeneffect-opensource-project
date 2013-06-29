class CreateUserAchievementAssociations < ActiveRecord::Migration
  def self.up
    create_table :user_achievement_associations do |t|
      t.integer :user_id
      t.integer :achievement_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_achievement_associations
  end
end
