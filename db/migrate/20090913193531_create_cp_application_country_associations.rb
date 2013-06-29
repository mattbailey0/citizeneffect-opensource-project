class CreateCpApplicationCountryAssociations < ActiveRecord::Migration
  def self.up
    create_table :cp_application_country_associations do |t|
      t.integer :cp_application_id
      t.integer :country_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cp_application_country_associations
  end
end
