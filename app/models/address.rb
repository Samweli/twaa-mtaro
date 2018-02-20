class Address
  include Geokit::Geocoders

  def self.geocode(address)
    OSMGeocoder.geocode(address)#.ll.split(',').map{|s| s.to_f}
  end
end
