require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
 
  require 'webrat'
 
  Webrat.configure do |config|
    config.mode = :rails
  end
 
  require 'webrat/core/matchers'
  require 'cucumber'
  require 'cucumber/formatter/unicode'
  require 'spec/rails'
  require 'cucumber/rails/rspec'
  require 'factory_girl'
  require 'culerity'
  $server ||= Culerity::run_server
  $browser = Culerity::RemoteBrowserProxy.new $server, {:browser => :firefox}
  $browser.webclient.setJavaScriptEnabled(true)
  require "#{RAILS_ROOT}/test/factories.rb"
  require "#{RAILS_ROOT}/db/bootstrap.rb"
end

Spork.each_run do
  # This code will be run each time you run your specs.
  Cucumber::Rails.bypass_rescue if Cucumber::Rails.respond_to?(:bypass_rescue)
end


# Sets up the Rails environment for Cucumber
#  ENV["RAILS_ENV"] ||= "test"
#  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
# require 'cucumber/rails/world'
# require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support
# Cucumber::Rails.use_transactional_fixtures
#  Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling 
#                                # (e.g. rescue_action_in_public / rescue_responses / rescue_from)

# require 'webrat'

# Webrat.configure do |config|
#   config.mode = :rails
# end

# require 'cucumber/rails/rspec'
# require 'webrat/core/matchers'

# require 'factory_girl'
# require "#{RAILS_ROOT}/test/factories.rb"

# require "#{RAILS_ROOT}/db/bootstrap.rb"

require 'fileutils'
FileUtils.touch "#{RAILS_ROOT}/tmp/restart.txt"

@@cucumber_cli_test_number = 1

Before do
  puts "--- TEST ##{@@cucumber_cli_test_number} ---"
  @@cucumber_cli_test_number += 1
  Bootstrapper.run :test
# 	tables = ActiveRecord::Base.connection.tables.sort.reject do |tbl|
#     ['schema_migrations'].include?(tbl)
#   end
#   tables.each do |table|
#     ActiveRecord::Base.connection.execute "delete from #{table}"
#   end
end
