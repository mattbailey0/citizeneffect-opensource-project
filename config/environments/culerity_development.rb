config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test


ONEWELL_HOST = "http://"

TWITTER_CONSUMER_TOKEN = ""
TWITTER_CONSUMER_SECRET = ""
FACEBOOK_SECRET = ""
FACEBOOK_APP_ID = ""

CYBERSOURCE_USERID = ""
CYBERSOURCE_TRANSACTION_KEY = ""

ActiveMerchant::Billing::Base.mode = :test

REQUIRE_SSL = false
