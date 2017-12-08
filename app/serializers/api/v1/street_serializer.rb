class Api::V1::StreetSerializer < Api::V1::BaseSerializer
  attributes :street_name, :ward_name, :municipal_name, :city_name, :lat, :lng, :id
end