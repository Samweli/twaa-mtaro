class Api::V1::StreetSerializer < Api::V1::BaseSerializer

  attributes :street_name, :ward, :lat, :lng, :name, :label, :value
  has_one :ward, embed: :objects

  def name
    object.street_name
  end

  def label
    object.street_name
  end

  def value
    object.street_name
  end
  def ward
    object.ward
  end
end