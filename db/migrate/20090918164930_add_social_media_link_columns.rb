class AddSocialMediaLinkColumns < ActiveRecord::Migration
  def self.up
    add_column "users", :twitter_path,  :string
    add_column "users", :linkedin_path, :string
    add_column "users", :facebook_path, :string
    add_column "users", :myspace_path,  :string
    add_column "users", :youtube_path,  :string
    add_column "users", :blog_url,      :string
    
    add_column "projects", :twitter_path,  :string
    add_column "projects", :facebook_path, :string
    add_column "projects", :youtube_path,  :string
    add_column "projects", :myspace_path,  :string
  end

  def self.down
    remove_column "users", :twitter_path,  :string
    remove_column "users", :linkedin_path, :string
    remove_column "users", :facebook_path, :string
    remove_column "users", :myspace_path,  :string
    remove_column "users", :youtube_path,  :string
    remove_column "users", :blog_url,      :string
    
    remove_column "projects", :twitter_path,  :string
    remove_column "projects", :facebook_path, :string
    remove_column "projects", :youtube_path,  :string
    remove_column "projects", :myspace_path,  :string
  end
end
