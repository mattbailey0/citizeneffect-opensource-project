require "#{File.dirname(__FILE__)}/../test_helper"
require "relevance/tarantula"

ActiveSupport::TestCase.use_transactional_fixtures = false

class TarantulaTest < ActionController::IntegrationTest
  # Load enough test data to ensure that there's a link to every page in your
  # application. Doing so allows Tarantula to follow those links and crawl 
  # every page.  For many applications, you can load a decent data set by
  # loading all fixtures.
#   fixtures :all

  def test_tarantula
    # If your application requires users to log in before accessing certain 
    # pages, uncomment the lines below and update them to allow this test to
    # log in to your application.  Doing so allows Tarantula to crawl the 
    # pages that are only accessible to logged-in users.
    # 
    #   post '/session', :login => 'quentin', :password => 'monkey'
    #   follow_redirect!
    
    cmd = "RAILS_ENV=test rake import_production_data DB_BACKUP_FILE=test/fixtures/some_file.sql.gz SOURCE_ENV=\"development\""
    puts "loading test data"
    system cmd

    post '/session', :login => 'some_user@some_url.com', :password => 'password'
    follow_redirect!
    
    tarantula_crawl(self, :url => admin_projects_path)
  end
end
