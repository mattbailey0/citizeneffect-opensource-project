class AddOtherLocationColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column "users", :city_name, :string
    add_column "users", :state_name, :string
  end

  def self.down
    remove_column "users", :state_name, :string
    remove_column "users", :city_name, :string
  end
end
