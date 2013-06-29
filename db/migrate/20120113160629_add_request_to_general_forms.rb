class AddRequestToGeneralForms < ActiveRecord::Migration
  def self.up
    add_column :general_forms, :request, :string
  end

  def self.down
    remove_column :general_forms, :request
  end
end
