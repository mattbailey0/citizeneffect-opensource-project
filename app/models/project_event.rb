class ProjectEvent < ActiveRecord::Base
  include CommonNamedScopes
  include GeocodeHelper
  include Icalendar

  acts_as_mappable
  before_save :update_geocode

  belongs_to :project
  belongs_to :fundraiser_type
  has_many   :event_attendance_responses
  has_many   :users, :through => :event_attendance_responses
  has_many   :media_album_displayers, :as => :displayer
  has_many   :media_albums, :through => :media_album_displayers
  has_many   :project_event_invitation_emails

  named_scope :upcoming,
              :order      => "event_start_time ASC",
              :conditions => { :event_start_time => Time.now.to_date..10.years.from_now.to_date }

  named_scope :previous,
              :order      => "event_start_time ASC",
              :conditions => { :event_start_time => 10.years.ago.to_date..Time.now.to_date }

  #validates_presence_of :host
  validates_presence_of :name
  validates_presence_of :fundraiser_type
  validates_presence_of :event_start_time
  validates_presence_of :event_end_time
  validate :end_time_after_start_time
  #validates_presence_of :address1
  #validates_presence_of :city
  #validates_presence_of :state
  #validates_presence_of :zip
  #validates_presence_of :country


  def end_time_after_start_time
    if self.event_start_time && self.event_end_time
      errors.add(:event_end_time, "must be after the event start time") unless
        self.event_end_time >= self.event_start_time
    end
  end

  def update_geocode
    if location_changed?
      self.geocode_address(self.long_location)
    end
  end

  def long_location
    "#{self.address1} #{self.address2} #{self.city} #{self.state} #{self.zip} #{self.country}"
  end

  def location_changed?
    (self.address1_changed? || self.address2_changed? || self.city_changed? ||
     self.state_changed? || self.zip_changed? || self.country_changed?) && !long_location.blank?
  end

  def self.near(options = {})
    defaults = {
      :within => 5,
      :limit => 5
    }

    options = options.dup.reverse_merge!(defaults)
    user = options.delete(:user)
    ip   = options.delete(:ip)

    results = []

    results = ProjectEvent.upcoming.find(:all, {:origin => user}.merge(options)) if !user.blank?

    if results.blank? && !ip.blank?
      geo_ip = Geokit::Geocoders::IpGeocoder.geocode(ip)
      results = ProjectEvent.upcoming.find(:all, {:origin => geo_ip}.merge(options)) if geo_ip.success
    end

    results
  end

  def users_with_no_response
    User.scoped(:include => :event_attendance_responses,
                :conditions => "event_attendance_responses.project_event_id = #{self.id} AND " +
                               "event_attendance_responses.response is null")
  end

  def users_attending
    User.scoped(:include => :event_attendance_responses,
                :conditions => "event_attendance_responses.project_event_id = #{self.id} AND " +
                               "event_attendance_responses.response = #{EventAttendanceResponse::YES}")
  end

  def users_not_attending
    User.scoped(:include => :event_attendance_responses,
                :conditions => "event_attendance_responses.project_event_id = #{self.id} AND " +
                               "event_attendance_responses.response = #{EventAttendanceResponse::NO}")
  end

  def users_maybe_attending
    User.scoped(:include => :event_attendance_responses,
                :conditions => "event_attendance_responses.project_event_id = #{self.id} AND " +
                               "event_attendance_responses.response = #{EventAttendanceResponse::MAYBE}")
  end

  # iCal stuff
  def to_ics(ics_url, for_outlook = false)
    cal = Calendar.new

    event = Event.new
    event.dtstart ics_start_datetime, {:TZID => "UTC" }
    event.dtend ics_end_datetime, { :TZID => "UTC" }
    event.summary = self.name

    event.location = ics_location
    event.url = ics_url
    event.description = ics_description(ics_url)

    cal.add_event(event)
    cal_out = cal.to_ical
    cal_out = cal_out.gsub('VERSION:2.0', '') if for_outlook

    cal_out
  end

  def ics_location
    (self.address1.blank? ? "" : "#{self.address1}, " ) +
      (self.address2.blank? ? "" : "#{self.address2}, ") +
      (self.city.blank? ? "" : "#{self.city}, " ) +
      (self.state.blank? ? "" : self.state )
  end

  def ics_description(ics_url)
    "#{self.short_description}\n\n#{self.long_description}\n\nMore details at #{ics_url}"
  end

  def ics_start_datetime
    self.class.ics_datetime(self.event_start_time.utc) # Note: utc_start_datetime should be different than the local time of the event
  end

  def ics_end_datetime
    self.class.ics_datetime(self.event_end_time.utc) # Note: utc_end_datetime should be different than the local time of the event
  end

  def self.ics_datetime(utc_time_obj)
    utc_time_obj.strftime('%Y%m%dT%H%M%SZ')
  end

  def duration_in_sec
    (self.event_end_time.utc - self.event_start_time.utc).round
  end
  # /iCal stuff
end

