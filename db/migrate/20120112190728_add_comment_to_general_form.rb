class AddCommentToGeneralForm < ActiveRecord::Migration
  def self.up
    add_column :general_forms, :comment, :string
  end

  def self.down
    remove_column :general_forms, :comment
  end
end
