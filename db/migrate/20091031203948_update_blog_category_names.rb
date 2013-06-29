class UpdateBlogCategoryNames < ActiveRecord::Migration
  def self.up
    BlogCategory.find_by_name("Education").andand.update_attributes(:name => "education")
    BlogCategory.find_by_name("Food").andand.update_attributes(:name      => "food security")
    BlogCategory.find_by_name("Medical").andand.update_attributes(:name   => "health")
    BlogCategory.find_by_name("Water").andand.update_attributes(:name     => "water & sanitation")
    BlogCategory.find_by_name("Wind").andand.update_attributes(:name      => "clean energy")
  end

  def self.down
  end
end
