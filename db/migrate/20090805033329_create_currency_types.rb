class CreateCurrencyTypes < ActiveRecord::Migration
  def self.up
    create_table :currency_types do |t|
      t.string :currency_code
      t.timestamps
    end
  end

  def self.down
    drop_table :currency_types
  end
end
