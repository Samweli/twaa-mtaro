class Api::V1::StreetSerializer < Api::V1::BaseSerializer

  attributes :street_name, :ward_id, :lat, :lng, :name, :label, :value

  def name
    object.street_name
  end

  def label
    object.street_name
  end

  def value
    object.street_name
  end
end