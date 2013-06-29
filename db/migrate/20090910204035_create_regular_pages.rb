class CreateRegularPages < ActiveRecord::Migration
  def self.up
    create_table :regular_pages do |t|
      t.string :title
      t.string :permalink_text
      t.string :meta_keywords
      t.string :meta_description
      t.text :content
      t.datetime :published_at
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :regular_pages
  end
end
