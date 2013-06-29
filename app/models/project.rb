class Project < ActiveRecord::Base
  include CommonNamedScopes
  include PermalinkHelper
  include SocialUrlHelper

  # READ_ONLY_FIELDS = [:cp_id, :name, :primary_benefits, :secondary_benefits, :partner_id]
  # READ_WRITE_FIELDS  = []
  # API_METHODS = [:summary, :community_summary, :start_date, :lives_impacted, :donated_dollars, :donor_count, :status, :community_name]
  # include ApiModelHelper

  named_scope :everything #this is so I can do crazy delegation in User

  named_scope :needing_a_cp, # STUB lazy eval until we have cooler DB constants
    lambda { { :conditions => { :project_status_id => ProjectStatus.awaiting_cp.id } } }

  named_scope :needing_donations, # STUB lazy eval until we have cooler DB constants
    lambda { { :conditions => { :project_status_id => ProjectStatus.fundraising.id } } }

  named_scope :user_visible_projects, # STUB lazy eval until we have cooler DB constants
    lambda { { :conditions => { :project_status_id => ProjectStatus.statuses_that_are_user_visible } } }

  named_scope :with_a_cp, # STUB lazy eval until we have cooler DB constants
    lambda { { :conditions => { :project_status_id => ProjectStatus.statuses_that_must_have_a_cp } } }

  named_scope :fundraising_completed, # STUB lazy eval until we have cooler DB constants
    lambda { { :conditions => { :project_status_id => ProjectStatus.statuses_that_must_be_done_fundraising } } }

  named_scope :recently_active,
              :include => :news_items,
              :order => "news_items.created_at DESC",
              :conditions => "news_items.id is not null"

  PRIORITIES = [
                HIGH_PRIORITY   = "High",
                MEDIUM_PRIORITY = "Medium",
                LOW_PRIORITY    = "Low",
               ]

  has_one_unified_attachment :detailed_project_budget
  belongs_to        :partner
  belongs_to        :project_status
  belongs_to        :lives_impacted_range
  belongs_to        :fundraising_goal_range
  belongs_to        :country
  belongs_to        :cp,            :class_name => "User"
  belongs_to        :primary_photo, :class_name => "MediaAlbumPhoto"
  belongs_to        :local_currency_type, :class_name => "CurrencyType"
  #belongs_to        :campaign, :class_name => "Campaign"
  has_one           :mailing_list
  has_one           :blog
  has_one           :partner_coordinator_association
  has_one           :partner_coordinator, :through => :partner_coordinator_association, :source => :user
  has_many          :project_focus_area_associations
  has_many          :focus_areas, :through => :project_focus_area_associations
  has_many          :project_type_associations
  has_many          :types, :through => :project_type_associations, :source => :project_type
  has_many          :community_member_profiles
  has_many          :events,   :class_name => "ProjectEvent"
  has_many          :donations
  has_many          :news_items, :as => :newsable
  has_many          :cp_applications
  has_many_unified_attachments :associated_files
  has_many          :media_albums
  has_many          :watched_project_associations
  has_many          :watchers, :through => :watched_project_associations, :source => "user"
  has_many          :project_campaign_associations
  has_many          :campaigns, :through => :project_campaign_associations

  has_one_external_text_column :primary_objective
  has_one_external_text_column :community_summary_for_website
  has_one_external_text_column :major_communities
  has_one_external_text_column :major_occupations
  has_one_external_text_column :brief_history_of_community
  has_one_external_text_column :weather
  has_one_external_text_column :major_issues
  has_one_external_text_column :summary_for_website
  has_one_external_text_column :justification_for_project
  has_one_external_text_column :what_will_be_done
  has_one_external_text_column :how_will_it_be_done
  has_one_external_text_column :environmental_sustainability
  has_one_external_text_column :economic_sustainability
  has_one_external_text_column :social_sustainability
  has_one_external_text_column :proposed_timeline
  has_one_external_text_column :agricultural_land
  has_one_external_text_column :animal_husbandry
  has_one_external_text_column :water_related_infrastructure
  has_one_external_text_column :sanitation
  has_one_external_text_column :healthcare_facilities
  has_one_external_text_column :transportation
  has_one_external_text_column :commerce
  has_one_external_text_column :education
  has_one_external_text_column :primary_benefits
  has_one_external_text_column :secondary_benefits

  has_permalink     :name, :permalink

  accepts_nested_attributes_for :primary_photo, :reject_if => lambda { |attrs| attrs["photo"].blank? }


  has_many_polymorphs :featured_medias,
                      :from => [:media_album_photos, :media_album_videos],
                      :through => :featured_media_associations,
                      :order => "featured_media_associations.position"
  reflect_on_association(:featured_media_associations).options[:order] = "position"

  accepts_nested_attributes_for :featured_media_associations,
                                :reject_if => lambda { |attrs|
    FeaturedMediaAssociation.reject_featured_media_attributes? attrs["featured_media_attributes"] }

  has_many_polymorphs :project_reports, :through => :project_report_associations,
                       :from => [
                                 :partner_project_final_reports,
                                 :partner_project_impact_reports,
                                 :partner_project_status_updates,
                                 :partner_project_progress_reports
                                ]

  define_index do
    indexes :name
    indexes [self.cp.first_name, self.cp.last_name], :as => :cp_name
    indexes self.country.name, :as => :country_name
    indexes self.partner.display_name, :as => :partner_name
    #indexes self.campaign.name, :as => :campaign

    has project_focus_area_associations.focus_area(:id), :as => :focus_area_ids, :source => :query
    has :country_id
    has :project_status_id
    has :lives_impacted_range_id
    has :fundraising_goal_range_id
    # set_property :delta => true
  end

  sphinx_scope(:sphinx_user_visible) {
    { :with => { :project_status_id => ProjectStatus.statuses_that_are_user_visible.map(&:id) } }
  }

  validates_presence_of :partner
  validates_presence_of :project_status
  validates_presence_of :summary_for_website
  validates_presence_of :justification_for_project
  validates_presence_of :what_will_be_done
  validates_presence_of :how_will_it_be_done
  validates_presence_of :total_cost_in_local_currency
  validates_presence_of :local_currency_type_id
  validates_presence_of :total_cost_in_us_cents
  validates_presence_of :community_name
  validates_presence_of :district_name
  validates_presence_of :community_state
  validates_presence_of :country_id
  validates_presence_of :community_population, :if => :community_population_required
  validates_presence_of :primary_lives_impacted
  validates_presence_of :secondary_lives_impacted
  validates_presence_of :district_coordinator
  validates_presence_of :community_leader
  validates_presence_of :name
  validates_presence_of :priority
  validates_presence_of :primary_objective
  validates_presence_of :desired_construction_start_date
  validates_inclusion_of :priority, :in => PRIORITIES
  validate :cp_has_cp_role, :if => Proc.new {|o| o.cp }
  validates_presence_of :cp, :if =>
    Proc.new { |p| ProjectStatus.statuses_that_must_have_a_cp.map(&:id).include?(p.project_status_id) }
  # Turned off fundraising completion enforcement at request of citizen effect 10/11/2011
  # validate :enforce_fundraising_completion, :if =>
  #  Proc.new { |p| ProjectStatus.statuses_that_must_be_done_fundraising.map(&:id).include?(p.project_status_id) }
  validates_length_of :featured_media_association_ids, :maximum => 10,
                      :message => "can't be more than {{count}}"

  validates_presence_of :card_image_url,    :if => :enable_card_donation
  validates_presence_of :card_snapfish_url, :if => :enable_card_donation
  validates_presence_of :card_donation_cost_in_cents, :if => :enable_card_donation

  before_create :new_blog_for_project, :new_mailing_list_for_project
  before_save :reconcile_state_and_cp, :update_project_state_updated_at,
              :update_approved_by_citizen_effect_at, :check_update_credit_card_fee
  after_save  :update_blog_url, :update_credit_card_fee

  def duplicate
    project = self.clone

    project.blog = nil                                                          #do not dupe bc holds project-specific posts
    project.detailed_project_budget = self.detailed_project_budget
    project.focus_areas = self.focus_areas
    project.mailing_list = nil                                                  #do not dupe bc includes project-specific contacts
#    project.media_albums = self.media_albums                                    #should not just dupe becuase this potentially includes project-specific media.  quick solution.
    project.name = "Duplicate Of #{self.name}"
    project.partner_coordinator = self.partner_coordinator
    project.primary_photo = self.primary_photo
    project.project_status = ProjectStatus.draft
    project.permalink = "#{self.permalink}-#{Project.last.id}"
    project.types = self.types

    [:primary_objective, :community_summary_for_website, :major_communities, :major_occupations,
     :brief_history_of_community, :weather, :major_issues, :summary_for_website, :justification_for_project,
     :what_will_be_done, :how_will_it_be_done, :environmental_sustainability, :economic_sustainability,
     :social_sustainability, :proposed_timeline, :agricultural_land, :animal_husbandry,
     :water_related_infrastructure, :sanitation, :healthcare_facilities, :transportation, :commerce,
     :education, :primary_benefits, :secondary_benefits].each do |col|
      project.send("#{col}=", self.send(col))
    end

    #project.save ? project : false

    if project.save
      self.featured_media_associations.each do |a|
        n = FeaturedMediaAssociation.new(a.attributes)
        n.project_id = project.id
        n.save!
      end
#    project.community_member_profiles = self.community_member_profiles
      return project
    else
      return false
    end


  end

  #TODO: fix this with a real constant class
  def after_initialize
    self.project_status ||= ProjectStatus.draft
  end

  def check_update_credit_card_fee
    @update_donations = self.no_credit_card_fee_changed?
    true
  end

  def update_credit_card_fee
    self.donations.map(&:save) if @update_donations
    true
  end

  def reconcile_state_and_cp
    if self.cp_id.nil? && ProjectStatus.statuses_that_are_user_visible.map(&:id).include?(self.project_status_id)
      self.project_status = ProjectStatus.awaiting_cp
    elsif !self.cp_id.nil? && self.project_status.id == ProjectStatus.awaiting_cp.id
      self.project_status = ProjectStatus.fundraising
    end
  end

  def update_project_state_updated_at
    self.state_updated_at = Time.now if self.project_status_id_changed?
  end

  def update_blog_url
    return if self.blog.nil?

    url_identifier = self.permalink.blank? ? self.id.to_s : self.permalink

    if(self.blog.url_identifier != url_identifier)
      self.blog.url_identifier = url_identifier
      self.blog.save
    end
  end

  def update_approved_by_citizen_effect_at
    if ProjectStatus.statuses_that_are_not_user_visible.map(&:id).include?(self.project_status_id)
      self.approved_by_citizen_effect_at = nil
    elsif self.approved_by_citizen_effect_at.blank?
      self.approved_by_citizen_effect_at = Time.now
    end
  end

  def project_reports=(value)
    self.project_reports.clear
    value.each do |report|
      self.project_reports << report
    end
  end

  def primary_photo_and_featured_medias # STUB, for project page carousel
    [self.primary_photo].compact + self.featured_medias
  end

  def donor_count
    Donation.count(:email, :distinct => true,
                :conditions => { :project_id => self.id } )
  end

  def new_blog_for_project
    self.blog = Blog.new(:title => self.name)
  end

  def new_mailing_list_for_project
    self.mailing_list = MailingList.new
  end

  def cp_has_cp_role
    self.errors.add_to_base("The user you are trying to associate with this project is not a CP") unless self.cp.andand.is_a_cp?
  end

  def enforce_fundraising_completion
    self.errors.add_to_base("Invalid Status - Fundraising has not been completed for this project") unless self.total_amount_raised_in_cents >= self.total_cost_in_us_cents
  end

  def cps_for_select
    Role.cp.users
  end

  def state
    self.project_status.display_name
  end

  def update_lives_impacted_range
    object.lives_impacted_range = LivesImpactedRange.fit_to_range(object.primary_lives_impacted || 0)
  end

  def percent_raised
    return 100 if self.total_cost_in_us_cents.to_f == 0

    value = ((self.total_amount_raised_in_cents.to_f / self.total_cost_in_us_cents.to_f) * 100).to_i
    [[value, 0].max, 100].min
  end

  def offline_donations
    self.donations.scoped(:conditions => {:offline => true}, :order => "donations.donated_at ASC")
  end

  def offline_donations_total_in_cents
#    self.offline_donations.sum(:project_amount_in_cents)
    #total = 0
    #self.offline_donations.each do |d|
    #  total += d.net_project_amount_in_cents
    #end
    #return total
    self.offline_donations.sum(:net_project_amount_in_cents)
  end


  def offline_donations_total_in_dollars
    MoneyConversion.cents_to_dollars(self.offline_donations_total_in_cents)
  end

  def online_donations_total_in_dollars
    online = self.total_amount_raised_in_cents - self.offline_donations_total_in_cents
    MoneyConversion.cents_to_dollars(online)
  end    
  
  def total_amount_raised_in_cents
    #total = 0
    #self.donations.each do |d|
    #  total += d.net_project_amount_in_cents
    #end
    #return total
    self.donations.sum(:net_project_amount_in_cents)
  end

  def total_amount_raised_in_usd
    MoneyConversion.cents_to_dollars(self.total_amount_raised_in_cents)
  end

  def amount_left_to_raise_in_usd
    self.total_cost_in_usd - self.total_amount_raised_in_usd
  end

  def total_cost_in_usd
    MoneyConversion.cents_to_dollars(self.total_cost_in_us_cents)
  end

  def total_cost_in_usd=(value)
    self.total_cost_in_us_cents = MoneyConversion.dollars_to_cents(value)
  end

  def card_donation_cost_in_usd
    MoneyConversion.cents_to_dollars(self.card_donation_cost_in_cents)
  end

  def card_donation_cost_in_usd=(value)
    self.card_donation_cost_in_cents = MoneyConversion.dollars_to_cents(value)
  end

  def partner_coordinator_id
    self.partner_coordinator.andand.id
  end

  def partner_coordinator_id=(integer)
    partner_coordinator_association = self.partner_coordinator_association || PartnerCoordinatorAssociation.create(:project_id => self.id, :user_id => integer)
    partner_coordinator_association.update_attribute("user_id", integer)
  end

  def people_who_liked_this_project_also_liked
    Project.user_visible_projects.random
  end

  def videos
    MediaAlbumVideo.scoped(:include => [:media_album_media, :media_album],
                            :conditions => "media_albums.project_id = #{self.id}",
                            :order => "media_album_medias.position")
  end

  def photos
    MediaAlbumPhoto.scoped(:include => [:media_album_media, :media_album],
                           :conditions => "media_albums.project_id = #{self.id}",
                           :order => "media_album_medias.position")
    #bad approach - misses any photos, such as primary_photo, which don't belong to a media_album
    #added photos_including_primary_photo as fix, but should consolidate, fix nomenclature
  end

  def photos_including_primary_photo
    MediaAlbumPhoto.scoped(:include => [:media_album_media, :media_album],
                           :conditions => "media_albums.project_id = #{self.id} OR media_album_photos.id = #{self.primary_photo.id}",
                           :order => "media_album_medias.position")  
  end
    
  def admin_and_partner_media_albums
    if cp
      self.media_albums.scoped(:conditions => "NOT user_id = #{cp.id}")
    else
      self.media_albums
    end
  end

  def cp_media_albums
    if cp
      self.media_albums.scoped(:conditions => { :user_id => cp.id })
    else
      []
    end
  end

  def type_icon_url(size_name = :standard_thumb)
    self.focus_areas.first.andand.icon_file || "icon_water.png"
  end

  def main_picture_url(size_name)
    self.primary_photo.andand.photo.andand.url(size_name) ||
      UnifiedUpload.new(:flavor => "project").url(size_name)
  end

  def main_picture_title
    self.primary_photo.andand.title || self.name_with_location
  end

  def main_picture_caption
    self.primary_photo.andand.description || self.primary_objective
  end

  def recent_blog_posts_count
    BlogPost.count(:conditions => { :created_at => 1.month.ago..Time.now, :blog_id => self.blog.id })
  end

  #returns count of *complete* blog posts for this project by the assigned CP
  def total_blog_posts_by_cp
    if self.cp_id
      BlogPost.count(:conditions => { :blog_id => self.blog.id, :posted_by_id => self.cp_id, :is_complete => 1})
    end
  end

  #returns most recent *complete* blog post for this project by the assigned CP
  def most_recent_blog_post_by_cp
    if self.cp_id
      BlogPost.find(:last, :conditions => { :blog_id => self.blog.id, :posted_by_id => self.cp_id, :is_complete => 1})
    end
  end

  def new_events_count
    ProjectEvent.count(:conditions => { :created_at => 1.month.ago..Time.now, :project_id => self.id })
  end

  def recent_announcements_count
    NewsItem.count(:conditions => {
                     :created_at    => 1.month.ago..Time.now,
                     :newsable_type => "Project",
                     :newsable_id   => self.id
                   })
  end

  def complete?
    ProjectStatus.statuses_that_count_as_completed.include? self.project_status
  end

  def in_progress?
    ProjectStatus.statuses_that_count_as_in_progress.include? self.project_status
  end

  def previous_events
    self.events.previous
  end

  def upcoming_events
    self.events.upcoming
  end

  def events_in_order
    self.events.scoped(:order => "event_start_time DESC")
  end

  def first_event
    self.events.first
  end

  def most_recent_event
    self.previous_events.last
  end

  def next_event
    self.upcoming_events.first
  end

  def display_location
    comma = (self.community_name.blank? || self.country.andand.name.blank?) ? "" : ", "
    "#{self.community_name}#{comma}#{self.country.andand.name}"
  end

  def name_with_cp
    (self.cp.blank? ? "" : "#{self.cp.first_name}'s ") + "#{self.name} Project"
  end

  def user_visible?
    ProjectStatus.statuses_that_are_user_visible.include?(self.project_status)
  end

  # This probably won't be used very much, since they are currently naming projects with the CP's name in it.
  def name_with_cp_and_location
    (self.name_with_cp.blank? ? "" : "#{self.name_with_cp} - ") + "#{self.display_location}"
  end

  def name_with_location
    "#{self.name} Project - #{self.display_location}"
  end

  def combined_lives_impacted
    self.primary_lives_impacted + (self.secondary_lives_impacted || 0)
  end

  # TODO make this a named scope? Or otherwise improve the code? mpm
  # Filter out any project report that isn't approved (but all status updates are OK)
  def status_updates_and_approved_project_reports
    status_updates_and_approved_project_reports = []
    self.project_reports.each do |proj_report|
      if proj_report.respond_to?("approval")
        if proj_report.approval && proj_report.approval.approved?
          status_updates_and_approved_project_reports << proj_report
        end
      else # a status update doesn't have an approval
        status_updates_and_approved_project_reports << proj_report
      end
    end
    status_updates_and_approved_project_reports
  end

  # Pretty methods for the API
  # Also, the syntax for alias sucks, and alias_method throws some bullshit.
  def summary
    summary_for_website
  end

  def community_summary
    community_summary_for_website
  end

  def start_date
    desired_construction_start_date
  end

  def lives_impacted
    combined_lives_impacted
  end

  def donated_dollars
    total_amount_raised_in_usd
  end

  def number_of_donors
    donor_count
  end

  def status
    state
  end

  def country_name
    country.name
  end
  
  def campaign
    self.campaigns.first
  end
end

