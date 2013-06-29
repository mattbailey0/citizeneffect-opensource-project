class CpApplication < ActiveRecord::Base
  include ApprovalStatusesHelper
  
  has_many :cp_application_country_associations
  has_many :countries,              :through => :cp_application_country_associations
  has_many :cp_application_focus_area_associations
  has_many :focus_areas,            :through => :cp_application_focus_area_associations
  has_one  :cp_application_lives_impacted_range_association
  has_one  :lives_impacted_range,   :through => :cp_application_lives_impacted_range_association
  has_one  :cp_application_fundraising_goal_range_association
  has_one  :fundraising_goal_range, :through => :cp_application_fundraising_goal_range_association
  has_one  :approvable_association, :as => :approvable
  has_one  :approval,               :through => :approvable_association
  belongs_to :user, :autosave => true
  belongs_to :project
  belongs_to :referrer,             :class_name => "User"
  belongs_to :referral_source
  
  delegate :first_name, :last_name, :name, :email, :address1, :address2, :city_name, :state_code, :zip, :phone_number, :to => :user
  delegate :first_name=, :last_name=, :name=, :email=, :address1=, :address2=, :city_name=, :state_code=, :zip=, :phone_number=, :to => :user
  
  attr_accessor :dont_send_application_email

  accepts_nested_attributes_for :focus_areas
  accepts_nested_attributes_for :cp_application_focus_area_associations
  
  accepts_nested_attributes_for :cp_application_lives_impacted_range_association
  accepts_nested_attributes_for :cp_application_fundraising_goal_range_association
  accepts_nested_attributes_for :lives_impacted_range

  validates_acceptance_of :terms_of_service, :on => :create
  validates_presence_of   :address1, :city_name, :phone_number, :state_code, :zip
  
  after_create :send_submission_email
  
  def send_submission_email
    unless dont_send_application_email
      email = CpApplicationSubmittedEmail.create(
                                                 :cp_application_id  => self.id,
                                                 :recipients         => [self.email]
                                                 )
      email.send_later(:send!)
    end
    
    email = NewCpApplicationEmail.create(:cp_application_id  => self.id)
    email.send_later(:send!)
  end
  
  def applicant_is_new_cp?
    !self.user.is_a_cp?
  end
  
  def applicant_projects_completed_count
    user.projects_completed.size
  end
  
  def approve!
    self.user.roles.add!(Role.cp)
    self.project.update_attributes!(:cp => self.user) unless self.project.nil? || self.project.cp
    unless CpApplicationApprovedEmail.find_by_cp_application_id(self.id)
      #email = CpApplicationApprovedEmail.create(
      #                                          :cp_application_id  => self.id,
      #                                          :recipients         => [self.email]
      #                                          )
      #email.send_later(:send!)
    end
  end
  
  def deny!
    unless CpApplicationDeniedEmail.find_by_cp_application_id(self.id)
      #email = CpApplicationDeniedEmail.create(
      #                                        :cp_application_id  => self.id,
      #                                        :recipients         => [self.email]
      #                                        )
      #email.send_later(:send!)
    end
  end
  
  def next_step
    nil #pulled in via approval status helper, but not a real thang
  end
  
  def approved?
    self.approval.andand.approved?
  end
  
  def denied?
    self.approval.andand.denied?
  end
end
