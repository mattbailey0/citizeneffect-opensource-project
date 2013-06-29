# Settings specified here will take precedence over those in config/environment.rb
ENV['PATH'] = ENV['PATH'] + ":" + File.join('', 'usr', 'bin') # so paperclip can find imagemagick in production

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
config.action_mailer.delivery_method = :smtp
config.action_mailer.default_url_options = {:host => "citizeneffect.org"}
config.action_mailer.smtp_settings = {
  :address  => "mail.authsmtp.com",
  :port  => 23, 
  :domain  => "citizeneffect.org",
  :user_name  => "",
  :password  => "",
  :authentication  => :login
}


# Enable threaded mode
# config.threadsafe!

TWITTER_CONSUMER_TOKEN = ""
TWITTER_CONSUMER_SECRET = ""

MYSPACE_CONSUMER_TOKEN = ""
MYSPACE_CONSUMER_SECRET = ""

FACEBOOK_SECRET = ""
FACEBOOK_APP_ID = ""


PAPERCLIP_OPTIONS = { 
  :storage        => :s3,
  :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
  :path           => ":attachment/:id/:style.:extension",
  :bucket         => "",
  :s3_host_alias  => "",
  :url            => ":s3_alias_url",
}

CYBERSOURCE_USERID = ""
CYBERSOURCE_TRANSACTION_KEY = ""

ActiveMerchant::Billing::Base.mode = :test

ONEWELL_HOST = ""

REQUIRE_SSL = true

SECURE_PROTOCOL = "https"

# this basically just changes it so TS doesn't actually check to see if the process is running
ThinkingSphinx.remote_sphinx = true

ActionController::Base.cache_store = :mem_cache_store, "localhost"
