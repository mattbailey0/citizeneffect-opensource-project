class MakeProjectsValid < ActiveRecord::Migration
  def self.up
    $SKIP_VALIDATIONS = false
    Project.reset_column_information
    Project.all.each do |p|
      p.summary_for_website             = "summary"            if p.summary_for_website            .blank? 
      p.justification_for_project       = "justification"      if p.justification_for_project      .blank? 
      p.what_will_be_done               = "stuff will be done" if p.what_will_be_done              .blank? 
      p.how_will_it_be_done             = "somehow"            if p.how_will_it_be_done            .blank? 
      p.total_cost_in_local_currency    = 0                    if p.total_cost_in_local_currency   .blank? 
      p.local_currency_type_id          = 1                    if p.local_currency_type_id         .blank? 
      p.total_cost_in_us_cents          = 0                    if p.total_cost_in_us_cents         .blank? 
      p.community_name                  = "commuinty"          if p.community_name                 .blank? 
      p.district_name                   = "district"           if p.district_name                  .blank? 
      p.community_state                 = "state"              if p.community_state                .blank? 
      p.country_id                      = 1                    if p.country_id                     .blank? 
      p.community_population            = 0                    if p.community_population           .blank? 
      p.primary_lives_impacted          = 0                    if p.primary_lives_impacted         .blank? 
      p.secondary_lives_impacted        = 0                    if p.secondary_lives_impacted       .blank? 
      p.district_coordinator            = "coordinator"        if p.district_coordinator           .blank? 
      p.community_leader                = "leader"             if p.community_leader               .blank? 
      p.name                            = "project name"       if p.name                           .blank? 
      p.priority                        = "High"               if p.priority                       .blank? 
      p.primary_objective               = "objective"          if p.primary_objective              .blank? 
      p.desired_construction_start_date = Time.now             if p.desired_construction_start_date.blank?
      
      if ProjectStatus.statuses_that_must_have_a_cp.include?(p.project_status) && p.cp.nil?
        p.cp = User.first
      end
      
      if ProjectStatus.statuses_that_must_be_done_fundraising.include?(p.project_status) && 
          p.total_amount_raised_in_cents < p.total_cost_in_us_cents
        p.project_status = ProjectStatus.fundraising
      end
      
      #run the observers, because they are currently disconnected
      FundraisingGoalObserver.update_fundraising_goal_range(p)
      LivesImpactedObserver.update_lives_impacted_range(p)
      NewsItem.create(:newsworthy_object => p)
      
      unless p.save
        o = p
        puts <<-STR
          WARNING ========================================================
            Couldn\'t update existing #{o.class.name} ID: #{o.id}
            errors: #{o.errors.full_messages.to_sentence}
            Continuing anyway
          WARNING ========================================================
        STR
      end
    end
  end

  def self.down
  end
  
  
  
end
