class CreateNgoCountryAssociations < ActiveRecord::Migration
  def self.up
    create_table :ngo_country_associations do |t|
      t.integer :country_id
      t.integer :ngo_id
      t.timestamps
    end
  end

  def self.down
    drop_table :ngo_country_associations
  end
end
