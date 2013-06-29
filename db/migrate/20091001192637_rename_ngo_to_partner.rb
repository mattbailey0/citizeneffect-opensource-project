class RenameNgoToPartner < ActiveRecord::Migration
  def self.up
    rename_table "ngos",                         :partners
    rename_table "ngo_user_details",             :partner_user_details
    rename_table "ngo_admin_associations",       :partner_admin_associations
    rename_table "ngo_country_associations",     :partner_country_associations
    rename_table "ngo_focus_area_associations",  :partner_focus_area_associations
    rename_table "ngo_coordinator_associations", :partner_coordinator_associations
    
    rename_column "projects", :sent_back_to_ngo_by_citizen_effect_at, :sent_back_to_partner_by_citizen_effect_at
    rename_column "projects",                         :ngo_id, :partner_id
    rename_column "partner_admin_associations",       :ngo_id, :partner_id
    rename_column "partner_country_associations",     :ngo_id, :partner_id
    rename_column "partner_focus_area_associations",  :ngo_id, :partner_id
    
    ngo_role = Role.find_by_name("ngo_admin")
    ngo_role.name = "partner_admin"
    ngo_role.description = "Admin for one or more Partners"
    unless ngo_role.save
      o = ngo_role
      puts <<-STR
        WARNING ========================================================
          Couldn\'t update existing #{o.class.name} ID: #{o.id}
          errors: #{o.errors.full_messages.to_sentence}
          Continuing anyway
        WARNING ========================================================
      STR
    end
    
    cp_role = Role.find_by_name("cp")
    cp_role.description = "Helps manage projects for Partners"
    unless cp_role.save
      o = cp_role
      puts <<-STR
        WARNING ========================================================
          Couldn\'t update existing #{o.class.name} ID: #{o.id}
          errors: #{o.errors.full_messages.to_sentence}
          Continuing anyway
        WARNING ========================================================
      STR
    end
  end

  def self.down
  end
end
