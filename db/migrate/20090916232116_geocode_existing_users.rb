class GeocodeExistingUsers < ActiveRecord::Migration
  def self.up
    User.all.each do |u|
      u.update_geocode
      unless u.save
        o = u
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
