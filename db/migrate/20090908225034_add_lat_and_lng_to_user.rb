class AddLatAndLngToUser < ActiveRecord::Migration
  def self.up
    add_column "users", :lat,      :float
    add_column "users", :lng,      :float
    add_column "users", :address1, :string
    add_column "users", :address2, :string
  end

  def self.down
    remove_column "users", :lat
    remove_column "users", :lng
    remove_column "users", :address1
    remove_column "users", :address2
  end
end
