class ProjectStatus < ActiveRecord::Base
  has_many :projects
  @@singleton_class = class << self; self; end
  
  # defines a class method for each of the statuses in the database
  def self.define_project_status_methods
    ProjectStatus.all.each do |project_status|
      method_name = project_status.method_name
      instance_variable_name = "@#{method_name}"

      block = Proc.new do
        if !instance_variable_defined?(instance_variable_name)
          instance_variable_set(instance_variable_name, self.find_by_method_name(method_name))
        end

        instance_variable_get(instance_variable_name)
      end
      
      @@singleton_class.send(:define_method, method_name, &block) 
      

    end 
  end
  define_project_status_methods if ActiveRecord::Base.interesting_tables.include?("project_statuses")
  
  def project_page_display_name
    case self.id
      when ProjectStatus.archive.id then "Evaluation"
      when ProjectStatus.construction_complete.id then "Completion"
      when ProjectStatus.under_construction.id then "Construction"
      when ProjectStatus.planning.id then "Construction"
      when ProjectStatus.fundraising.id then "Fundraising"
      when ProjectStatus.awaiting_cp.id then "Fundraising"
      else "Proposal"
    end
  end
  
  def self.statuses_that_count_as_in_progress
    [
     ProjectStatus.awaiting_cp,
     ProjectStatus.fundraising,
    ]
  end
  
  def self.statuses_that_count_as_completed
    [
     ProjectStatus.planning,
     ProjectStatus.under_construction,
     ProjectStatus.construction_complete,
     ProjectStatus.archive
    ]
  end
  
  def self.statuses_that_are_user_visible
    [
     ProjectStatus.awaiting_cp,
     ProjectStatus.fundraising,
     ProjectStatus.under_construction,
     ProjectStatus.planning,
     ProjectStatus.archive,
     ProjectStatus.construction_complete
    ]
  end

  def self.statuses_that_are_not_user_visible
    [
     ProjectStatus.draft,
     ProjectStatus.new_project,
     ProjectStatus.approval_process,
     ProjectStatus.needs_more_information,
     ProjectStatus.denied
    ]
  end
  
  def self.statuses_that_must_have_a_cp
    [
     ProjectStatus.fundraising,
     ProjectStatus.under_construction,
     ProjectStatus.planning,
     ProjectStatus.archive,
     ProjectStatus.construction_complete
    ]
  end
  
  def self.statuses_that_must_be_done_fundraising
    [
     ProjectStatus.planning,
     ProjectStatus.under_construction,
     ProjectStatus.archive,
     ProjectStatus.construction_complete
    ]
  end
  
  def project_page_display_name
    case self.id
      when ProjectStatus.archive.id then "Evaluation"
      when ProjectStatus.construction_complete.id then "Completion"
      when ProjectStatus.under_construction.id then "Construction"
      when ProjectStatus.planning.id then "Construction"
      when ProjectStatus.fundraising.id then "Fundraising"
      when ProjectStatus.awaiting_cp.id then "Fundraising"
      else "Proposal"
    end
  end
  
  def get_status_progress
    consolidated_name = self.project_page_display_name
    case consolidated_name
    when "Proposal" then { 
        :proposal => "current_project_status",
        :fundraising => "future_project_status",
        :construction => "future_project_status",
        :completion => "future_project_status",
        :evaluation => "future_project_status"
      }
    when "Fundraising" then {
        :proposal => "completed_project_status",
        :fundraising => "current_project_status",
        :construction => "future_project_status",
        :completion => "future_project_status",
        :evaluation => "future_project_status",
      }
    when "Construction" then {
        :proposal => "completed_project_status",
        :fundraising => "completed_project_status",
        :construction => "current_project_status",
        :completion => "future_project_status",
        :evaluation => "future_project_status",
      }
    when "Completion" then {
        :proposal => "completed_project_status",
        :fundraising => "completed_project_status",
        :construction => "completed_project_status",
        :completion => "current_project_status",
        :evaluation => "future_project_status",
      }
    when "Evaluation" then {
        :proposal => "completed_project_status",
        :fundraising => "completed_project_status",
        :construction => "completed_project_status",
        :completion => "completed_project_status",
        :evaluation => "current_project_status",
      }
    end
  end
  
end
