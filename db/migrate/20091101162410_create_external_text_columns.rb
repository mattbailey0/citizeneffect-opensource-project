class CreateExternalTextColumns < ActiveRecord::Migration
  def self.up
    create_table :external_text_columns do |t|
      t.string  :column_owner_type
      t.integer :column_owner_id
      t.string  :flavor
      t.text    :content
      t.timestamps
    end
  end

  def self.down
    drop_table :external_text_columns
  end
end
