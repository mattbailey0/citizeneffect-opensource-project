class MoveProjectTextToExternalColumns < ActiveRecord::Migration
  def self.up
    Project.external_text_columns = nil # clear this out so we can still use read_attribute
    Project.all.each do |p|
      p.primary_objective                   = p.read_attribute(:primary_objective            )         
      p.community_summary_for_website       = p.read_attribute(:community_summary_for_website) 
      p.major_communities                   = p.read_attribute(:major_communities            )         
      p.major_occupations                   = p.read_attribute(:major_occupations            )         
      p.brief_history_of_community          = p.read_attribute(:brief_history_of_community   ) 
      p.weather                             = p.read_attribute(:weather                      )         
      p.major_issues                        = p.read_attribute(:major_issues                 )         
      p.summary_for_website                 = p.read_attribute(:summary_for_website          )         
      p.justification_for_project           = p.read_attribute(:justification_for_project    ) 
      p.what_will_be_done                   = p.read_attribute(:what_will_be_done            )         
      p.how_will_it_be_done                 = p.read_attribute(:how_will_it_be_done          )         
      p.environmental_sustainability        = p.read_attribute(:environmental_sustainability ) 
      p.economic_sustainability             = p.read_attribute(:economic_sustainability      ) 
      p.social_sustainability               = p.read_attribute(:social_sustainability        ) 
      p.proposed_timeline                   = p.read_attribute(:proposed_timeline            )         
      p.agricultural_land                   = p.read_attribute(:agricultural_land            )         
      p.animal_husbandry                    = p.read_attribute(:animal_husbandry             )         
      p.water_related_infrastructure        = p.read_attribute(:water_related_infrastructure ) 
      p.sanitation                          = p.read_attribute(:sanitation                   )         
      p.healthcare_facilities               = p.read_attribute(:healthcare_facilities        ) 
      p.transportation                      = p.read_attribute(:transportation               )         
      p.commerce                            = p.read_attribute(:commerce                     )        
      p.education                           = p.read_attribute(:education                    )         
      p.primary_benefits                    = p.read_attribute(:primary_benefits             )         
      p.secondary_benefits                  = p.read_attribute(:secondary_benefits           )         
      
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
    
    remove_column "projects", :primary_objective            
    remove_column "projects", :community_summary_for_website
    remove_column "projects", :major_communities            
    remove_column "projects", :major_occupations            
    remove_column "projects", :brief_history_of_community   
    remove_column "projects", :weather                      
    remove_column "projects", :major_issues                 
    remove_column "projects", :summary_for_website          
    remove_column "projects", :justification_for_project    
    remove_column "projects", :what_will_be_done            
    remove_column "projects", :how_will_it_be_done          
    remove_column "projects", :environmental_sustainability 
    remove_column "projects", :economic_sustainability      
    remove_column "projects", :social_sustainability        
    remove_column "projects", :proposed_timeline            
    remove_column "projects", :agricultural_land            
    remove_column "projects", :animal_husbandry             
    remove_column "projects", :water_related_infrastructure 
    remove_column "projects", :sanitation                   
    remove_column "projects", :healthcare_facilities        
    remove_column "projects", :transportation               
    remove_column "projects", :commerce                     
    remove_column "projects", :education                    
    remove_column "projects", :primary_benefits             
    remove_column "projects", :secondary_benefits           
    
  end

  def self.down
  end
end
