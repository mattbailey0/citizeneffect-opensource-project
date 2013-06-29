class AddPrimaryPhotoToProject < ActiveRecord::Migration
  def self.up
    add_column "projects", :primary_photo_id, :integer
  end

  def self.down
    remove_column "projects", :primary_photo_id, :integer
  end
end
