# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.default_url_options = {:host => ""}
config.action_mailer.delivery_method = :test

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql

#config.gem 'expectedbehavior-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
config.gem 'factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'


ENV["JAVA_MEM"] = "-Xmx1024m"

ONEWELL_HOST = ""

config.gem 'relevance-tarantula', :source => "http://gems.github.com", :lib => 'relevance/tarantula'
config.gem 'redgreen'
#config.gem "spork"

TWITTER_CONSUMER_TOKEN = ""
TWITTER_CONSUMER_SECRET = ""
FACEBOOK_SECRET = ""
FACEBOOK_APP_ID = ""

PAPERCLIP_OPTIONS = { }

CYBERSOURCE_USERID = ""
CYBERSOURCE_TRANSACTION_KEY = ""

ActiveMerchant::Billing::Base.mode = :test

REQUIRE_SSL = false

SECURE_PROTOCOL = "http"

unless ENV['NO_DEBUG']
  require 'ruby-debug'
  Debugger.start
  rc_file = File.join(File.dirname(File.dirname(__FILE__)), 'rdebugrc')
  Debugger.run_script rc_file if File.exists?(rc_file)
end

