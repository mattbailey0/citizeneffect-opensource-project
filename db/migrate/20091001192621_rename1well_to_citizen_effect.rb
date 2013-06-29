class Rename1wellToCitizenEffect < ActiveRecord::Migration
  def self.up
    #fix column names
    rename_column "projects", :approved_by_1well_at,         :approved_by_citizen_effect_at
    rename_column "projects", :denied_by_1well_at,           :denied_by_citizen_effect_at
    rename_column "projects", :sent_back_to_ngo_by_1well_at, :sent_back_to_ngo_by_citizen_effect_at

    #fix role name
    admin = Role.find_by_name("1well_admin")
    admin.name = "citizen_effect_admin"
    unless admin.save
      o = admin
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
    #fix column names
    rename_column "projects", :approved_by_citizen_effect_at,         :approved_by_1well_at
    rename_column "projects", :denied_by_citizen_effect_at,           :denied_by_1well_at
    rename_column "projects", :sent_back_to_ngo_by_citizen_effect_at, :sent_back_to_ngo_by_1well_at

    #fix role name
    admin = Role.find_by_name("citizen_effect_admin")
    admin.name = "1well_admin"
    unless admin.save
      o = admin
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
