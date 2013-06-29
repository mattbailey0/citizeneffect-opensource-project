class AddLatToPartner < ActiveRecord::Migration
  def self.up
    add_column :partners, :lat, :float
  end

  def self.down
    remove_column :partners, :lat
  end
end
