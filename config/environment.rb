# Be sure to restart your server when you modify this file

# add jruby at the end of the path for culerity
ENV['PATH'] ||= "" # EY Solo has this as null and it causes an exception
ENV['PATH'] = ENV['PATH'] + ":" + File.join(File.dirname(__FILE__), '..', 'vendor', 'jruby-1.3.1', 'bin')
ENV['PATH'] = ENV['PATH'] + ":" + File.join('', 'opt', 'local', 'bin') # so paperclip can find imagemagick


# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require 'thread' #for rubygems >1.5
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

if Gem::VERSION >= "1.3.6"
  module Rails
    class GemDependency
      def requirement
        r = super
        (r == Gem::Requirement.default) ? nil : r
      end
    end
  end
end

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.


  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"

  config.gem 'aasm', :lib => 'aasm'
  config.gem "twitter", :version => "0.9.0"#disabled and moved later in the load sequence to solve HTTParty versioning issue. MB 11/1/12
  config.gem "ruby-openid", :lib => "openid", :version => ">= 2.1.7"
  config.gem "myspaceid-sdk", :lib => "myspace"
  config.gem "httparty"
  config.gem "geokit", :version => "1.4.1"
  config.gem "adamhunter-contacts", :lib => "contacts"
  config.gem "activemerchant", :lib => "active_merchant"
  config.gem "whenever", :lib => false
  config.gem "bitly"
  config.gem "has_many_polymorphs"
  config.gem "aws-s3", :lib => "aws/s3"
  config.gem 'google_analytics', :lib => 'rubaidh/google_analytics'
  config.gem 'icalendar'
  config.gem 'exceptional', :version => '2.0.6'
  config.gem 'doc_raptor'
  config.gem 'rabl'

  #config.gem 'will_paginate', :version => '2.3.16'

  #config.gem "semanticart-is_paranoid", :lib => 'is_paranoid', :version => ">= 0.0.1"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )


  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  #unless (ARGV.include?("db:migrate") || ARGV.include?("db:schema:load")) #line added to prevent observer classes from being loaded during migrations and schema loads.  causes bonk in new environments.
  config.active_record.observers = [
                                    :user_observer,
                                    :lives_impacted_observer,
                                    :fundraising_goal_observer,
                                    :news_item_observer,
                                    :imported_contact_observer,
                                    :donation_observer
                                   ]
  #end 
  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

EMAIL_FROM_ADDRESS = ""

require 'andand'

# Paperclip.options[:log_command] = true

Paperclip.interpolates :flavor do |attachment, style|
  attachment.instance.flavor
end

#make it so we get up to 1000 instead of only 25
Contacts::Gmail::CONTACTS_FEED.replace(Contacts::Gmail::CONTACTS_FEED + "?max-results=1000")

DocRaptor.api_key ""
Mime::Type.register "application/vnd.ms-excel", :xls
Mime::Type.register "application/pdf", :pdf

