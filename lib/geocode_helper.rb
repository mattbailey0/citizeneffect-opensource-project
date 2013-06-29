module GeocodeHelper

  def geocode_address(address)
    geo = Geokit::Geocoders::GoogleGeocoder.geocode(address)
    if geo.success
      self.lat = geo.lat
      self.lng = geo.lng
      geo
    else
      errors.add(:address, "Could not Geocode address")
      false
    end
  end
  
end
