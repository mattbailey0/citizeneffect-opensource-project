class MoveToUnifiedAttachment < ActiveRecord::Migration
  def self.up
    Partner.class_eval do
      has_attached_file :logo
      has_attached_file :representative_picture
    end
    
    Project.class_eval do
      has_attached_file :detailed_project_budget
    end
    
    logos = { }
    pictures = { }
    Partner.all.each do |p|
      logos[p.id] = p.logo.path if p.logo
      pictures[p.id] = p.representative_picture.path if p.representative_picture
    end
    
    budgets = { }
    Project.all.each do |p|
      budgets[p.id] = p.detailed_project_budget.path if p.detailed_project_budget
    end
    
    Partner.class_eval do
      has_one_unified_attachment :logo
      has_one_unified_attachment :representative_picture
    end
    
    Project.class_eval do
      has_one_unified_attachment :detailed_project_budget
    end
    
    remove_column "projects", :detailed_project_budget_file_name
    remove_column "projects", :detailed_project_budget_content_type
    remove_column "projects", :detailed_project_budget_file_size
    remove_column "projects", :detailed_project_budget_updated_at
    
    remove_column "partners", :logo_file_name
    remove_column "partners", :logo_content_type
    remove_column "partners", :logo_file_size
    remove_column "partners", :logo_updated_at
    remove_column "partners", :representative_picture_file_name
    remove_column "partners", :representative_picture_content_type
    remove_column "partners", :representative_picture_file_size
    remove_column "partners", :representative_picture_updated_at

    Partner.all.each do |p|
      p.logo = File.open(logos[p.id]) if logos[p.id] && File.exists?(logos[p.id])
      p.representative_picture = File.open(pictures[p.id]) if pictures[p.id] && File.exists?(pictures[p.id])
    end
    
    Project.all.each do |p|
      p.detailed_project_budget = File.open(budgets[p.id]) if budgets[p.id] && File.exists?(budgets[p.id])
    end
  end

  def self.down
  end
end
