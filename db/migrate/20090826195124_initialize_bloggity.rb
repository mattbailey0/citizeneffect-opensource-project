class InitializeBloggity < ActiveRecord::Migration
  def self.up
    `(cd #{RAILS_ROOT} && RAILS_ENV=#{RAILS_ENV} rake bloggity:bootstrap_db)`
    
    add_column "blog_posts", :excerpt, :text
  end

  def self.down
    remove_column "blog_posts", :excerpt, :text
  end
end
