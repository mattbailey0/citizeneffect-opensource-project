class CreateFeaturedMediaAssociations < ActiveRecord::Migration
  def self.up
    create_table :featured_media_associations do |t|
      t.integer  :project_id
      t.integer  :position
      t.integer  :featured_media_id
      t.string   :featured_media_type
      t.timestamps
    end
  end

  def self.down
    drop_table :featured_media_associations
  end
end
