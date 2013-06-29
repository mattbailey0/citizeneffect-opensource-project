# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

config.gem 'factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'


# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
config.action_mailer.default_url_options = {:host => ""}
config.action_mailer.delivery_method = :test

TWITTER_CONSUMER_TOKEN = ""
TWITTER_CONSUMER_SECRET = ""

MYSPACE_CONSUMER_TOKEN = ""
MYSPACE_CONSUMER_SECRET = ''

FACEBOOK_SECRET = ""
FACEBOOK_APP_ID = ""

CYBERSOURCE_USERID = ""
CYBERSOURCE_TRANSACTION_KEY = ""

ONEWELL_HOST = ""

PAPERCLIP_OPTIONS = {
  :storage         => :s3,
  :s3_credentials  => "#{RAILS_ROOT}/config/amazon_s3.yml",
  :path            => ":attachment/:id/:style.:extension",
  :bucket          => "",
  :s3_host_alias   => "",
  :url             => ":s3_alias_url",
}

ActiveMerchant::Billing::Base.mode = :test

REQUIRE_SSL = false

SECURE_PROTOCOL = "http"

unless ENV['NO_DEBUG']
  require 'ruby-debug'
  Debugger.start

  # if you comment our Debugger.start, and comment this in, you can use rdebug -c to debug under passenger
#   Debugger.wait_connection = true
#   Debugger.start_remote

  rc_file = File.join(File.dirname(File.dirname(__FILE__)), 'rdebugrc')
  Debugger.run_script rc_file if File.exists?(rc_file)
end

