class CreateNewsItems < ActiveRecord::Migration
  def self.up
    create_table :news_items do |t|
      t.string  :newsable_type
      t.integer :newsable_id
      t.string  :news_item_type
      t.text    :news_message
      t.timestamps
    end
    NewsItem.reset_column_information
  end

  def self.down
    drop_table :news_items
  end
end
