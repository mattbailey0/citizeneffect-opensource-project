require File.expand_path(File.dirname(__FILE__) + "/../bootstrap.rb")

class CreateAchievements < ActiveRecord::Migration
  def self.up
    create_table :achievements do |t|
      t.integer  :achievement_type
      t.integer  :reference_amount
      t.string   :name
      t.timestamps
    end
    
    Bootstrapper.run :achievements
  end

  def self.down
    drop_table :achievements
  end
end
