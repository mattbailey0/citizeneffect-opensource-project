class AddLngToPartner < ActiveRecord::Migration
  def self.up
    add_column :partners, :lng, :float
  end

  def self.down
    remove_column :partners, :lng
  end
end
