class CreateUnifiedUploads < ActiveRecord::Migration
  def self.up
    create_table :unified_uploads do |t|
      t.string  :uploadable_type
      t.integer :uploadable_id
      t.string  :flavor
      t.string  :content_file_name
      t.string  :content_content_type
      t.string  :content_file_size
      t.string  :content_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :unified_uploads
  end
end
