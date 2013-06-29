class ChangeIsTomsToTwoFields < ActiveRecord::Migration
  def self.up
    rename_column :projects, :is_toms_project, :no_credit_card_fee
    add_column    :projects, :no_tip_request,  :boolean, :allow_nil => false, :default => false
    
    Project.reset_column_information
    
    Project.find_each do |p|
      p.no_tip_request = p.no_credit_card_fee
      p.save
    end
  end

  def self.down
  end
end
