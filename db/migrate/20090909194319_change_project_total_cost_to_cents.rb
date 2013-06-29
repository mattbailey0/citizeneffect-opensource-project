class ChangeProjectTotalCostToCents < ActiveRecord::Migration
  def self.up
    rename_column "projects", :total_cost_in_usd, :total_cost_in_us_cents
    Project.reset_column_information
    Project.all.each do |p|
      p.total_cost_in_us_cents = p.total_cost_in_us_cents.to_i * 100
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
