class Achievement < ActiveRecord::Base
  CP_PROJECTS_COMPLETED       = 1
  CP_MONEY_RAISED_IN_PROJECTS = 2
  CP_LIVES_IMPACTED           = 3  
  DONOR_PROJECTS_DONATED      = 4
  DONOR_MONEY_DONATED         = 5
  DONOR_LIVES_IMPACTED        = 6
  
  ACHIEVEMENT_TYPES = [
                       CP_PROJECTS_COMPLETED,
                       CP_MONEY_RAISED_IN_PROJECTS,
                       CP_LIVES_IMPACTED,
                       DONOR_PROJECTS_DONATED,
                       DONOR_MONEY_DONATED,
                       DONOR_LIVES_IMPACTED,
                      ]
  
  has_many :user_achievement_associations
  
  named_scope :donor_achievements, :conditions => { :achievement_type => [
                                                                          DONOR_PROJECTS_DONATED,
                                                                          DONOR_MONEY_DONATED,
                                                                          DONOR_LIVES_IMPACTED
                                                                         ]}
  
  named_scope :cp_achievements, :conditions => { :achievement_type => [
                                                                          CP_PROJECTS_COMPLETED,
                                                                          CP_MONEY_RAISED_IN_PROJECTS,
                                                                          CP_LIVES_IMPACTED
                                                                         ]}
  
  
  validates_presence_of     :name
  validates_numericality_of :reference_amount, :greater_than_or_equal_to => 0, :only_integer => true
  validates_inclusion_of    :achievement_type, :in => ACHIEVEMENT_TYPES
  
  def self.update_all_achievement_associations()
    User.all.each do |user|
      determine_achievements_for_user(:user => user, :apply => true)
    end
  end
  
  def self.determine_achievements_for_user(options)
    user = options[:user]
    results = []
    results << self.determine_cp_projects_completed_achievements(user)
    results << self.determine_cp_money_raised_in_projects_achievements(user)
    results << self.determine_cp_lives_impacted_achievements(user)
    results << self.determine_donor_projects_donated_achievements(user)
    results << self.determine_donor_money_donated_achievements(user)
    results << self.determine_donor_lives_impacted_achievements(user)
    results.flatten!
    associate_achievements(:user => user, :achievements => results) if(options[:apply])
    results
  end
  
  def reference_amount_in_dollars
    MoneyConversion.cents_to_dollars(self.reference_amount)
  end
  
  protected
    
  def self.associate_achievements(options)
    user = options[:user]
    UserAchievementAssociation.delete_all(:user_id => user.id)

    options[:achievements].each do |achievement|
      UserAchievementAssociation.create(:user => user, :achievement => achievement)
    end
  end
  
  def self.determine_cp_projects_completed_achievements(user)
    self.get_achievements_of_type_and_range(CP_PROJECTS_COMPLETED, 0..user.projects_completed.count)
  end
  
  def self.determine_cp_money_raised_in_projects_achievements(user)
    self.get_achievements_of_type_and_range(CP_MONEY_RAISED_IN_PROJECTS, 0..user.money_raised_in_cents)
  end
    
  def self.determine_cp_lives_impacted_achievements(user)
    self.get_achievements_of_type_and_range(CP_LIVES_IMPACTED, 0..user.lives_impacted_as_cp)
  end
  
  def self.determine_donor_projects_donated_achievements(user)
    self.get_achievements_of_type_and_range(DONOR_PROJECTS_DONATED, 0..user.projects_donated_to.count)
  end
  
  def self.determine_donor_money_donated_achievements(user)
    self.get_achievements_of_type_and_range(DONOR_MONEY_DONATED, 0..user.donation_total_in_cents)
  end
    
  def self.determine_donor_lives_impacted_achievements(user)
    self.get_achievements_of_type_and_range(DONOR_LIVES_IMPACTED, 0..user.lives_impacted_as_donor)
  end
  
  def self.get_achievements_of_type_and_range(type, range)
    Achievement.find(:all,
                     :conditions => { 
                       :achievement_type => type,
                       :reference_amount => range
                     })
  end
  
end
