require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles
  include BloggityRequiredMethods
  include ContactManagement
  include GeocodeHelper
  include NewsFeedHelpers
  include CommonNamedScopes
  include SocialUrlHelper

  #oauth support
  has_many :client_applications
  has_many :tokens, :class_name => "OauthToken", :order => "authorized_at desc", :include => [:client_application]
  #/oauth support
  
  PROFILE_TODO_LIST =
    [
     {
       :image     => "icon_facebook_connect.png",
       :attribute => :display_facebook_todo,
       :link      => lambda { |user, view| [:link_to_facebook, user] }
     },
     {
       :image     => "icon_twitter_signin.png",
       :attribute => :display_twitter_todo,
       :link      => lambda { |user, view| [:link_to_twitter, user] }
     },
     {
       :image     => "icon_myspace_id.png",
       :attribute => :display_myspace_todo,
       :link      => lambda { |user, view| [:link_to_myspace, user] }
     },
     {
       :text      => "Import Email Address Book",
       :attribute => :display_contact_todo,
       :link      => lambda { |user, view| view.send(:imported_contacts_path) }
     },
     {
       :text      => "Invite Users to Citizen Effect",
       :attribute => :display_invite_todo,
       :link      => lambda { |user, view| view.send(:new_from_import_imported_contact_path) }
     }
    ]

  acts_as_mappable

  has_many :user_role_associations
  has_many :roles, :through => :user_role_associations, :uniq => true do
    def add!(role)
      UserRoleAssociation.create(:role => role, :user => proxy_owner) unless self.include?(role)
    end

    def remove!(role)
      UserRoleAssociation.find(:all, :conditions => {:role_id => role.id, :user_id => proxy_owner.id}).map(&:destroy)
    end
  end

  named_scope :top_cps, # STUB lazy eval until we have cooler DB constants
    lambda { {
              :joins => "LEFT JOIN projects ON users.id = projects.cp_id",
              :select => "users.*, (sum(projects.primary_lives_impacted) + sum(projects.secondary_lives_impacted)) as lives_impacted_as_cp",
              :order => "lives_impacted_as_cp DESC",
              :group => "users.id",
              :conditions => "projects.project_status_id IN (" +
                             "#{ProjectStatus.statuses_that_count_as_completed.map(&:id).join(',')})"

    } }

  named_scope :top_networkers,
              :joins => "LEFT JOIN imported_contacts ON users.id = imported_contacts.referrer_id",
              :select => "users.*, count(imported_contacts.id) as users_recruited",
              :order => "users_recruited DESC",
              :group => "users.id",
              :conditions => "imported_contacts.recruited = true"

  has_private_messages
  belongs_to        :details, :polymorphic => true
  has_many          :blog_posts
  has_many          :blog_comments
  has_many          :partner_admin_associations
  has_many          :imported_contacts, :foreign_key => "referrer_id"
  has_many          :watched_project_associations
  has_many          :watched_projects, :through => :watched_project_associations, :source => "project"
  has_many          :mailing_list_users
  has_many          :mailing_lists, :through => :mailing_list_users
  has_many          :event_attendance_responses
  has_many          :user_achievement_associations
  has_many          :achievements, :through => :user_achievement_associations
  has_many          :donations, :foreign_key => "donor_id"
  has_one_unified_attachment :picture

  delegate          :permissions, :to => :role

  before_create :make_activation_code
  before_save :update_geocode, :if => Proc.new {|o| o.address_changed? }

  validates_presence_of   :email
  validates_length_of     :email, :within => 6..100 #r@a.wk
  validates_uniqueness_of :email
  validates_format_of     :email, :with => Authentication.email_regex, :message => Authentication.bad_email_message
  #validates_presence_of   :zip
  validates_length_of     :roles, :minimum => 1 # everyone should have at least the basic_user role

  define_index do
    indexes :first_name, :last_name
  end

  attr_accessor :referral_code, :do_not_send_emails
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :roles, :skype_username, :phone_number, :zip,
  :first_name, :last_name, :city_name, :state_name, :twitter_access_key, :twitter_secret_key, :facebook_auth_token,
  :facebook_session_key, :facebook_uid, :address1, :address2, :state_code, :donation_ids, :picture, :blog_url,
  :referral_code, :youtube_path, :facebook_path, :twitter_path, :myspace_path, :linkedin_path, :about_me,
  :blog_url, :display_contact_todo, :display_twitter_todo, :display_invite_todo, :display_facebook_todo,
  :display_myspace_todo

  def after_initialize
    basic_user_role = Role.find_or_create_by_name("basic_user")
    self.roles << basic_user_role unless self.roles.include?(basic_user_role)
  end

  def self.new_from_api(attributes_hash)
    new({
      :first_name => attributes_hash[:first_name],
      :last_name => attributes_hash[:last_name],
      :email => attributes_hash[:email],
      :zip => attributes_hash[:zip],
      :password => attributes_hash[:password],
      :password_confirmation => attributes_hash[:password_confirmation],
    })
  end

  def lives_impacted_as_cp
    self.projects_completed.sum(:primary_lives_impacted) + self.projects_completed.sum(:secondary_lives_impacted)
  end

  def lives_impacted_as_donor
    self.projects_donated_to.sum(:primary_lives_impacted) + self.projects_donated_to.sum(:secondary_lives_impacted)
  end

  def lives_impacted
    as_cp = self.lives_impacted_as_cp
    as_donor = self.lives_impacted_as_donor
    as_donor > as_cp ? as_donor : as_cp
  end

  def users_recruited_count
    self.imported_contacts.count("id", :conditions => { :recruited => true })
  end

  def donation_total_in_cents
    self.donations.scoped(:conditions => {:anonymous => false}).sum(:actual_amount_in_cents)
  end

  def donation_total_in_usd
    MoneyConversion.cents_to_dollars(self.donation_total_in_cents)
  end

  def money_raised_in_cents
    Donation.sum(:project_amount_in_cents, :conditions => { :donation_attribution_id => self.id })
  end

  def money_raised_in_usd
    MoneyConversion.cents_to_dollars(self.money_raised_in_cents)
  end

  def events_nearby
    ProjectEvent.find(:all, :origin => self, :within => 5, :limit => 5)
  end

  def picture_url_thumb(size_name = :standard_thumb)
    self.picture.andand.url(size_name) || UnifiedUpload.new(:flavor => "user").url(size_name)
  end

  def campaigns(*args)
    @campaigns ||= Campaign.everything
    #more permissions go here!
  end

  def partners(*args)
    if self.is_a_citizen_effect_admin?
      @partners ||= Partner.everything
    else
      @partners ||= Partner.scoped(:include => :partner_admin_associations, :conditions => "partner_admin_associations.user_id = #{self.id}")
    end
  end

  def projects(*args)
    if self.is_a_citizen_effect_admin?
      @projects ||= Project.everything
    elsif self.is_an_partner_admin?
      @projects ||= Project.scoped(:conditions => {:partner_id => self.partners.map(&:id)})
    elsif self.is_a_cp?
      @projects ||= self.cped_projects
#      self.projects_donated_to
    else
      [] # you must be new here
    end
  end
  alias :editable_projects :projects

  # Partner admins cannot edit the public project page, only the project page in the admin side
  def projects_editable_on_public_site
    if self.is_a_citizen_effect_admin?
      @projects ||= Project.everything
    elsif self.is_a_cp?
      @projects ||= self.cped_projects
#      self.projects_donated_to
    else
      [] # no dice
    end
  end

  def cped_projects
    Project.scoped(:conditions => {:cp_id => self.id})
  end

  def projects_with_a_cp_donated_to
    self.projects_donated_to.scoped(:conditions => "projects.cp_id is not null")
  end

  def projects_with_a_cp_donated_to_anonymously
    self.projects_donated_to_anonymously.scoped(:conditions => "projects.cp_id is not null")
  end

  def projects_donated_to
    Project.scoped(:include => :donations,
                   :conditions => "donations.donor_id = #{self.id} AND NOT donations.anonymous")
  end

  def projects_donated_to_anonymously
    Project.scoped(:include => :donations,
                   :conditions => "donations.donor_id = #{self.id} AND donations.anonymous")
  end

  def projects_in_progress
    self.cped_projects.scoped(:conditions => {
                     :project_status_id => ProjectStatus.statuses_that_count_as_in_progress
                   })
  end

  def projects_completed
    self.cped_projects.scoped(:conditions => {
                     :project_status_id => ProjectStatus.statuses_that_count_as_completed
                   })
  end

  def cps_supported
    User.scoped(
                :select => "users.*",
                :joins => "LEFT OUTER JOIN projects ON projects.cp_id = users.id " +
                          "LEFT OUTER JOIN donations ON donations.project_id = projects.id",
                :conditions => "donations.donor_id = #{self.id} AND NOT donations.anonymous"
                )
  end

  # We used to have user belong_to :role, but we went platinum on it.
  # It's handy to have this method, though
  def self.find_by_role_id(id)
    UserRoleAssociation.find(:first, :include => :user, :conditions => {:role_id => id})
  end

  def self.find_all_by_role_id(id)
    UserRoleAssociation.find(:all, :include => :user, :conditions => {:role_id => id}).map(&:user)
  end

  def self.find_all_without_role_id(id)
    users_with_the_role = User.find_all_by_role_id(id).map(&:id)
    User.find(:all, :conditions => ["id NOT IN (?)", users_with_the_role.join(",")])
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def name_and_email
    "#{self.name} (#{self.email})"
  end

  def display_location
    comma = (self.city_name.blank? || self.state_name.blank?) ? "" : ", "
    "#{self.city_name}#{comma}#{self.state_name}"
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank?
    if password.blank?
      u = find_by_api_key(login)
    else
      u = find_in_state :first, :active, :conditions => {:email => login.downcase} # need to get the salt
      u && u.authenticated?(password) ? u : nil
    end
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def display_facebook_todo
    self.read_attribute("display_facebook_todo") && !self.can_push_facebook_status?
  end

  def display_twitter_todo
    self.read_attribute("display_twitter_todo") && !self.can_push_twitter_status?
  end

  def display_myspace_todo
    self.read_attribute("display_myspace_todo") && !self.can_push_myspace_status?
  end

  def display_contact_todo
    self.read_attribute("display_contact_todo") && self.imported_contacts.empty?
  end

  def display_invite_todo
    self.read_attribute("display_invite_todo") &&
      self.imported_contacts.scoped(:conditions => "referral_code is not null").empty?
  end

  def show_todo_list?
    self.display_facebook_todo || self.display_twitter_todo || self.display_invite_todo ||
      self.display_myspace_todo || self.display_contact_todo
  end

  def can_push_any_status?
    self.can_push_twitter_status? || self.can_push_myspace_status? || can_push_facebook_status?
  end

  def can_push_twitter_status?
    twitter_access_key != nil && twitter_secret_key != nil
  end

  def can_push_myspace_status?
    myspace_access_key != nil && myspace_secret_key != nil
  end

  def can_push_facebook_status?
    facebook_auth_token != nil
  end

  def push_twitter_status(status)
    return false if !can_push_twitter_status?

    oauth = Twitter::OAuth.new(TWITTER_CONSUMER_TOKEN, TWITTER_CONSUMER_SECRET)
    oauth.authorize_from_access(twitter_access_key, twitter_secret_key)

    client = Twitter::Base.new(oauth)
    client.update(status)
  end

  def push_myspace_status(status)
    return false if !can_push_myspace_status?

    myspace = MySpace::MySpace.new(MYSPACE_CONSUMER_TOKEN, MYSPACE_CONSUMER_SECRET,
                                   :access_token => self.myspace_access_key,
                                   :access_token_secret => self.myspace_secret_key)

    myspace.set_status(myspace.get_userid, status)
  end

  def push_facebook_status(status)
    return false if !can_push_facebook_status?

    Facebook.push_status(self.facebook_auth_token, status)
  end

  def address_changed?
    self.address1_changed? || self.address2_changed? || self.zip_changed?
  end

  def update_geocode
    result = geocode_address("#{self.address1} #{self.address2} #{self.zip}")
    if(result)
      self.city_name = result.city
      self.state_code = self.state_name = result.state #todo: lookup table for state code to state name?
    end
  end

  def reset_password
    new_password = Digest::MD5.hexdigest("#{self.id}#{Time.now.to_i}")[0...8]

    self.password = new_password
    self.password_confirmation = new_password
    self.save

    email = PasswordResetEmail.create(
                                      :user_id        => self.id,
                                      :recipients     => [self.email],
                                      :reset_password => new_password
                                      )
    email.send_later(:send!)
  end

  # this largely handles the permission stuff while also delegating some method calls to details
  # This is not the best way to do this readability-wise, but I'll fix it later(?)
  def method_missing(method_id, *args)
#    debugger if method_id.to_s =~ /onewell/
    if match = matches_dynamic_role_check?(method_id)
      tokenize_roles(match.captures.first).each do |check|
        return true if self.roles.any? {|role| role.andand.name.andand.downcase == check }
      end
      return false
    elsif match = matches_dynamic_perm_check?(method_id)
      if self.roles.any? {|r| self.role.andand.permissions && permissions.find_by_name(match.captures.first) }
        return true
      else
        return false
      end
    else
      super
    end
  end

  def valid_dynamic_authorization_check?(method_id)
    matches_dynamic_role_check?(method_id) or matches_dynamic_perm_check?(method_id)
  end

  # we have to have this because association_proxy.rb calls respond_to? in its method_missing
  # instead of just passing things along
  def respond_to?(*args)
    self.valid_dynamic_authorization_check?(args[0]) or super
  end

  def watches_project?(project)
    WatchedProjectAssociation.exists?(:project_id => project.id, :user_id => self.id)
  end

  def enable_api!
    if self.roles.include?(Role.partner_admin)
      self.generate_api_key!
    end
  end

  def disable_api!
    self.update_attribute(:api_key, "")
  end

  def api_is_enabled?
    !self.api_key.blank?
  end

  def can_access_api?
    self.roles.include?(Role.partner_admin)
  end

  def twitter_url
     "http://twitter.com/#{twitter_path}" unless twitter_path.blank?
  end

  def facebook_url
    "http://www.facebook.com/#{facebook_path}" unless facebook_path.blank?
  end

  def linkedin_url
    "http://linkedin.com/#{linkedin_path}" unless linkedin_path.blank?
  end

  def youtube_url
    "http://www.youtube.com/#{youtube_path}" unless youtube_path.blank?
  end

  def myspace_url
    "http://www.myspace.com/#{myspace_path}" unless myspace_path.blank?
  end

  protected

    def make_activation_code
      self.deleted_at = nil
      self.activation_code = self.class.make_token
    end

    def secure_digest(*args)
      Digest::SHA1.hexdigest(args.flatten.join('--'))
    end

    def generate_api_key!
      self.update_attribute(:api_key, secure_digest(Time.now, (1..10).map{ rand.to_s }))
    end

  private

    def matches_dynamic_role_check?(method_id)
      /^is_an?_([a-zA-Z0-9]\w*)\?$/.match(method_id.to_s)
    end

    def tokenize_roles(string_to_split)
      string_to_split.split(/_or_/)
    end

    def matches_dynamic_perm_check?(method_id)
      /^can_([a-zA-Z0-9]\w*)\?$/.match(method_id.to_s)
    end
end

